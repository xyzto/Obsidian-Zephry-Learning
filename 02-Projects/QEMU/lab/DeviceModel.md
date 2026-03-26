# 实验15 驱动模型深度验证：从 DT 到 struct device

> 日期：2026-03-22
> 目标板：qemu_cortex_m3
> 关联 Concept：[[01-Concepts/DEVICE_DT_DEFINE]] | [[01-Concepts/Zephyr驱动模型]]

## 目标

理解 Zephyr 如何通过设备树（DeviceTree）的 compatible 属性自动关联驱动程序，并在内核启动阶段（main 之前）自动完成硬件初始化，实现应用层与底层寄存器操作的完全解耦。

## 关键机制

**声明（DT）**：在 .dts 或 .overlay 中定义节点，赋予 compatible 字符串（如 "gpio-leds"）。  
**绑定（Driver）**：驱动源码中使用 DEVICE_DT_INST_DEFINE 宏。编译器根据 compatible 匹配结果，将驱动初始化函数地址存入特定 Linker Section（如 .z_device_PRE_KERNEL_1_）。  
**执行（Kernel）**：内核启动时，z_sys_init_run_level 遍历该段内存，像执行插件一样逐个调用初始化函数。应用层无需手动调用 init()。  
**用户侧**：通过 DEVICE_DT_GET(DT_ALIAS(xxx)) 或 DEVICE_DT_GET(DT_NODELABEL(xxx)) 拿到已初始化的 struct device *，零感知使用。

## 源码位置

→ 源码路径：drivers/gpio/gpio_stm32.c 、drivers/led/led_gpio.c 、include/zephyr/device.h  
→ 关键函数：gpio_stm32_init 、led_gpio_init 、DEVICE_DT_INST_DEFINE

## 源码

### app.overlay

```dts
#include <zephyr/dt-bindings/gpio/gpio.h>

/ {
    leds: leds { 
        compatible = "gpio-leds";
        led_node: led_0 {
            gpios = <&gpio0 0 GPIO_ACTIVE_HIGH>;
            label = "Test LED";
        };
    };

    aliases {
        led0 = &leds; 
    };
};
```

### main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/gpio.h>

int main(void) {
    // 通过别名获取设备实例指针
    const struct device *dev = DEVICE_DT_GET(DT_ALIAS(led0));

    if (!device_is_ready(dev)) {
        printk("Device %s is NOT ready!\n", dev->name);
        return 0;
    }

    printk("GPIO Device Name: %s\n", dev->name);
    printk("Check kernel device list... Done.\n");
    return 0;
}
```

### prj.conf

```ini
CONFIG_GPIO=y
CONFIG_LED=y  # 必须开启子系统支持，驱动才会被编译
```

## 运行命令

```bash
west build -b qemu_cortex_m3
west build -t run
```

## 现象

在 qemu_cortex_m3 上需配合 gpio-emul 或类似虚拟 gpio 节点才能真正触发 led_gpio 驱动初始化；默认无真实 gpio0 节点时，device_is_ready() 返回 false，打印 "Device ... is NOT ready!"。  
（实验重点验证绑定逻辑而非真实 LED 闪烁，故现象符合预期）

## 坑

**现象**：__device_dts_ord_xxx undeclared  
**原因**：DT 节点未定义或 Alias 指向错误  
**解决**：检查 .overlay 是否生效，确保序号匹配  

**现象**：expected number... in overlay  
**原因**：缺少 DTS 宏定义头文件  
**解决**：加入 #include <zephyr/dt-bindings/gpio/gpio.h>  

**现象**：undefined reference to __device_...  
**原因**：驱动未编译进内核（Kconfig 缺失）  
**解决**：在 prj.conf 开启 CONFIG_LED  

**现象**：no LEDs found (child nodes missing)  
**原因**：compatible 放在了叶子节点而非父节点  
**解决**：遵循驱动要求的层级结构：父节点配驱动，子节点配参数

## 结论

Zephyr 驱动模型实现了**“描述即实现”**。  
- 硬件解耦：更换芯片只需改 DTS，不需要改 main.c。  
- 顺序自动化：通过初始化等级（PRE_KERNEL_1 等）自动解决外设间的依赖顺序。  
- 内存布局：利用链接器段（Section）实现静态注册，避免动态内存分配的不确定性。  
QEMU 与 STM32F103ZE 差异：QEMU 下 gpio_stm32/led_gpio 多为模拟或不执行，实板上会真实操作 RCC/GPIO 寄存器，但绑定/初始化流程完全相同。

## 疑问与解答

**Q：为什么 CONFIG_LED=y 是必须的？**  
A：它启用 LED 子系统（drivers/led/），进而拉入 led_gpio.c 等驱动实现；单纯 CONFIG_GPIO=y 只启用 GPIO 底层，不包含 LED 抽象层。

## 反哺

→ [[01-Concepts/DEVICE_DT_DEFINE]]  
→ [[01-Concepts/Zephyr驱动模型]]