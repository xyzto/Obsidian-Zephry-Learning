# 实验 14：GPIO 基础与中断 (模拟环境)

> **日期**：2026-03-22
> 
> **目标板**：`qemu_cortex_m3`
> 
> **核心概念**：[[DeviceTree Overlay]] | [[GPIO Callback]] | [[Interrupt Handling]]

## 1. 实验目标

在不具备物理硬件的情况下，通过 Zephyr 设备树插件（Overlay）在模拟器中构造虚拟 GPIO 硬件，并实现从“电平触发”到“应用层回调”的完整链路。

## 2. 项目结构与配置

### A. 设备树 (app.overlay)

由于 QEMU 默认板级文件没有 LED 和按键别名，必须手动“焊”上虚拟引脚。


```d
#include <zephyr/dt-bindings/gpio/gpio.h>

/ {
    aliases {
        led0 = &led_node;
        sw0 = &button_node;
    };

    leds {
        compatible = "gpio-leds";
        led_node: led_0 {
            gpios = <&gpio0 0 GPIO_ACTIVE_HIGH>; 
            label = "User LED";
        };
    };

    buttons {
        compatible = "gpio-keys";
        button_node: button_0 {
            gpios = <&gpio0 1 (GPIO_PULL_UP | GPIO_ACTIVE_LOW)>;
            label = "User Button";
        };
    };
};
```

### B. 项目配置 (prj.conf)

```ini
CONFIG_GPIO=y
```

## 3. 源码实现 (main.c)
```c
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/gpio.h>

/* 获取设备树定义的规格信息 */
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(DT_ALIAS(led0), gpios);
static const struct gpio_dt_spec button = GPIO_DT_SPEC_GET(DT_ALIAS(sw0), gpios);

/* 定义回调结构体：必须是 static 或全局变量，防止栈溢出后指针失效 */
static struct gpio_callback button_cb_data;

void button_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
    printk("GPIO Interrupt Triggered! Time: %d ms\n", k_uptime_get_32());
    gpio_pin_toggle_dt(&led); // 翻转虚拟 LED
}

int main(void)
{
    if (!gpio_is_ready_dt(&led) || !gpio_is_ready_dt(&button)) {
        return 0;
    }

    /* 1. 配置引脚模式 */
    gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
    gpio_pin_configure_dt(&button, GPIO_INPUT);

    /* 2. 配置中断触发条件：上升沿（从无效到有效） */
    gpio_pin_interrupt_configure_dt(&button, GPIO_INT_EDGE_TO_ACTIVE);

    /* 3. 初始化并挂载回调函数 */
    gpio_init_callback(&button_cb_data, button_pressed, BIT(button.pin));
    gpio_add_callback(button.port, &button_cb_data);

    printk("GPIO Demo Start. Manually triggering in 1s...\n");
    k_sleep(K_MSEC(1000));

    /* 4. 代码自测：手动拉高电平，模拟按键物理动作 */
    gpio_pin_set_dt(&button, 1); 

    while (1) {
        k_sleep(K_FOREVER);
    }
}
```

## 4. 实验复盘

### 关键点：生命周期

`gpio_add_callback` 只是将 `button_cb_data` 的**地址**存入内核链表。如果该变量定义在函数内部且没有 `static` 修饰，函数退出后内存会被回收，中断发生时会导致内核访问非法地址（Kernel Panic）。

### 关键点：Syscall 跳转

在开启了用户模式保护的系统中，`gpio_pin_...` 等 API 实际上会跳转到 `syscalls/gpio.h` 生成的跳板函数中。在 GDB 调试时，若发现断点位置异常，这是正常现象，说明系统调用机制正在生效。

## 5. 运行结果

Plaintext

```
*** Booting Zephyr OS build zephyr-v3.5.0 ***
GPIO Demo Start. Manually triggering in 1s...
GPIO Interrupt Triggered! Time: 1012 ms
```

---

