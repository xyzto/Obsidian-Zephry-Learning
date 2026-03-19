# 如何从零推导 prj.conf 和 app.overlay？

> 来源：Zephyr 30天训练计划实践
> 状态：#已验证
> 关联概念：[[Kconfig]] | [[Overlay]] | [[DeviceTree]] | [[Zephyr开发流程]]

## 当前理解

面对空白项目，不需要死记配置项，用"需求反推"的方式：代码里用了什么 API，就开什么 CONFIG；外设接在哪里，就在 overlay 里描述哪里。

## prj.conf 推导法

**代码 → 配置** 的逆向推导：

| 代码里用到 | prj.conf 需要加 |
|-----------|----------------|
| `gpio_xxx()` | `CONFIG_GPIO=y` |
| `printk()` | `CONFIG_PRINTK=y` |
| `uart_xxx()` | `CONFIG_UART=y` |
| `i2c_xxx()` | `CONFIG_I2C=y` |
| `LOG_INF()` | `CONFIG_LOG=y` |
| 浮点运算 | `CONFIG_FPU=y` |

不确定配置名时，两种查法：
1. `west build -t menuconfig` → 按 `/` 搜索关键词
2. [Zephyr Kconfig 搜索页](https://docs.zephyrproject.org/latest/kconfig.html)

新功能最快的方式：去 `zephyr/samples/` 找类似例子，直接复制它的 `prj.conf`。

## app.overlay 推导法

三步走：

1. **查控制器真名**：先 `west build`，打开 `build/zephyr/zephyr.dts`，搜索 `gpio`，确认叫 `gpio0` 还是 `gpioa`
2. **套模板**：
```dts
#include <zephyr/dt-bindings/gpio/gpio.h>
/ {
    aliases { led-status = &my_led; };
    leds {
        compatible = "gpio-leds";
        my_led: led_0 {
            gpios = <&gpio0 7 GPIO_ACTIVE_HIGH>;
        };
    };
};
```
3. **验证合并**：编译后再看 `build/zephyr/zephyr.dts` 确认 alias 正确

参考样例：
- LED 写法：`zephyr/samples/basic/blinky`
- 按键写法：`zephyr/samples/basic/button`

## 结论

```
不知道开什么 CONFIG → menuconfig 搜索 或 抄 samples
不知道引脚怎么填  → 先看 zephyr.dts 确认控制器真名
编译后不生效      → west build -p always 清理缓存重编
```

## 关联
[[Kconfig]] | [[Overlay]] | [[West]] | [[Zephyr开发流程]]
