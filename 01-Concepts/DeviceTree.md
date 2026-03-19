# DeviceTree

> 关联概念：[[Overlay]] | [[Kconfig]] | [[Zephyr]] | [[Zephyr编译系统]]

## 一、本质

DeviceTree 是 Zephyr 的**硬件描述语言**，用来告诉内核"这块板子上有什么硬件、怎么连接"。

```
.dts 文件（硬件描述）
    ↓ 编译时解析
devicetree_generated.h（C 语言宏）
    ↓
驱动通过 DT_* 宏找到硬件
```

传统裸机开发换引脚要改 C 代码；Zephyr 中只改 DTS，C 代码不动。

---

## 二、核心概念

| 概念 | 含义 | 示例 |
|------|------|------|
| 节点 (Node) | 一个硬件模块 | `uart0: uart@4000c000 { }` |
| 属性 (Property) | 硬件参数 | `current-speed = <115200>;` |
| compatible | 驱动匹配字符串 | `"gpio-leds"` |
| status | 设备是否启用 | `"okay"` / `"disabled"` |
| label | 节点的引用名 | `uart0` |

---

## 三、DTS 基本语法

```dts
/ {                              /* 根节点 */
    soc {
        uart0: uart@4000c000 {   /* 节点：标签: 名称@地址 */
            compatible = "ns16550";
            reg = <0x4000c000 0x1000>;
            status = "okay";
            current-speed = <115200>;
        };
    };
};
```

---

## 四、在 C 代码中访问设备树

```c
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>

/* 从设备树获取 uart0 节点 */
#define UART0_NODE DT_NODELABEL(uart0)

int main(void) {
    const struct device *dev = DEVICE_DT_GET(UART0_NODE);

    if (!device_is_ready(dev)) {
        return -1;
    }
    /* 现在可以调用 UART 驱动接口 */
}
```

常用 DT 宏：

| 宏 | 用途 |
|----|------|
| `DT_NODELABEL(label)` | 通过标签获取节点 |
| `DEVICE_DT_GET(node)` | 获取设备结构体指针 |
| `DT_ALIAS(alias)` | 通过别名获取节点 |
| `DT_PROP(node, prop)` | 读取节点属性值 |

---

## 五、文件层级

| 文件 | 来源 | 作用 |
|------|------|------|
| `board.dts` | Zephyr 官方 | 板子的基础硬件定义 |
| `soc.dtsi` | Zephyr 官方 | 芯片级定义（被 board.dts 包含） |
| `app.overlay` | 你的项目 | 应用级修改，叠加在 board.dts 上 |
| `zephyr.dts` | 编译生成 | 三者合并后的最终设备树 |

**永远不要修改官方的 board.dts，用 Overlay 代替。** 详见 [[Overlay]]。

---

## 六、验证设备树合并结果

编译后查看最终合并的设备树：

```bash
# 合并后的完整设备树
build/zephyr/zephyr.dts

# 生成的 C 语言宏
build/zephyr/include/generated/devicetree_generated.h
```

在 `zephyr.dts` 里搜索 `gpio` 可以确认控制器的真实标签名（`gpio0` 还是 `gpioa`），这是写 Overlay 前必须做的第一步。
