# 设备树覆盖 (Devicetree Overlay)

> 日期：2026-03-26
> 
> 目标板：qemu_cortex_m3
> 
> 关联 Concept：[[01-Concepts/DeviceTree]] | [[01-Concepts/Zephyr驱动模型]]

## 目标

**核心目标**：掌握在不修改板级原始 `.dts` 文件的情况下，通过 `app.overlay` 修改硬件配置（如改变引脚状态、修改别名指向），理解 Zephyr 编译时设备树合并的优先级机制。

## 关键机制

**覆盖机制**：构建系统按“板级 dts -> SoC dtsi -> 目录层级 Overlay -> 应用级 Overlay”顺序合并，后载入的节点属性会覆盖前者。

**节点状态**：通过设置 `status = "okay"` 或 `status = "disabled"` 在软件层面控制驱动实例的挂载。

**Label 引用**：使用 `&label` 语法直接定位原始树中的节点，避免重复定义层级结构。

**硬件解耦**：业务逻辑通过 Alias（别名）访问硬件，硬件差异被屏蔽在设备树层，实现一套代码适配多款硬件。

## 源码位置

→ 源码路径：`scripts/dts/gen_defines.py`、`cmake/modules/dts.cmake`

→ 关键函数：无（此过程由 Python 脚本在编译预处理阶段完成）

## 源码

### main.c
```c
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/gpio.h>

/* 检查设备树中是否定义了别名 led0 */
#define LED0_NODE DT_ALIAS(led0)

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

int main(void)
{
    if (!device_is_ready(led.port)) {
        return 0;
    }

    gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);

    while (1) {
        gpio_pin_toggle_dt(&led);
        k_msleep(500);
    }
    return 0;
}
```

### prj.conf

```ini
CONFIG_GPIO=y
```

### app.overlay
```d
/ {
    aliases {
        /* 通过覆盖别名，将代码逻辑指向另一个硬件引脚 */
        led0 = &custom_led;
    };

    leds {
        compatible = "gpio-leds";
        custom_led: led_1 {
            /* 模拟将 LED 挂载到 Port A 的 Pin 5 */
            gpios = <&gpio0 5 GPIO_ACTIVE_HIGH>;
            label = "Custom User LED";
        };
    };
};

&gpio0 {
    status = "okay";
};
```

## 运行命令
```Bash
west build -b qemu_cortex_m3
west build -t run
```

## 现象

1. 终端输出 `*** Booting Zephyr OS build zephyr-v3.5.0 ***`。
    
2. 检查 `build/zephyr/zephyr.dts`，确认 `aliases` 节点下的 `led0` 已指向 `/leds/led_1`。
    

## 坑

**现象**：修改 Overlay 后重新编译，发现 `zephyr.dts` 没更新。

**原因**：CMake 缓存可能未检测到 Overlay 文件的变动。

**解决**：彻底删除 `build` 目录或执行 `west build -p always` 进行完整构建。

## 结论

本实验成功验证了设备树覆盖机制。通过 `app.overlay` 成功修改了硬件配置，实现了业务代码与硬件底层定义的彻底分离。

## 疑问与解答

**Q：为什么 QEMU 运行时看不到 LED 闪烁？**

A：QEMU 模拟的是指令集和部分外设寄存器，并没有图形化的 LED。验证此类实验的核心在于检查编译生成的 `zephyr.dts` 是否符合预期，以及代码是否能成功获取到设备对象。

---

**Q：STM32 实板迁移时，`gpios` 属性要注意什么？**

A：必须对应 STM32 具体的控制器 Label（如 `&gpioa`），且引脚索引需参考原理图。同时必须确保该控制器在设备树中被设为 `status = "okay"`。

## 反哺

→ [[01-Concepts/DeviceTree]]