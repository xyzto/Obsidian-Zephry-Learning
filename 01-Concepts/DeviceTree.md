既然我们已经掌握了 **Kconfig**（控制软件功能的开关），现在就要进入 Zephyr 的另一半灵魂：**设备树 (DeviceTree, 简称 DT)**。

如果说 Kconfig 是在配置“大脑的功能”，那么设备树就是在描述“身体的构造”。在嵌入式开发中，这是实现**软硬件解耦**的神器。

---

### 1. 设备树的基本语法与结构

设备树是一种树状数据结构，用来描述硬件（CPU、内存、外设、引脚）。它以 `.dts`（源文件）和 `.dtsi`（包含文件）的形式存在。

**核心语法要素：**

- **节点 (Nodes)**：代表一个硬件模块（如 `uart0`）。
    
- **属性 (Properties)**：描述硬件参数（如波特率、寄存器地址）。
    
- **层级 (Hierarchy)**：反映总线结构（如 I2C 总线下挂载的传感器）。
    

Code snippet

```
/ {
    soc {
        uart0: uart@4000c000 {
            compatible = "ti,stellaris-uart";
            reg = <0x4000c000 0x1000>;
            status = "okay";
        };
    };
};
```

---

### 2. 设备树在 Zephyr 中的作用

在传统单片机开发（如裸机 STM32）中，如果你换了一个引脚接串口，你得去修改 C 代码里的宏定义。

而在 Zephyr 中：

1. **描述硬件**：`.dts` 文件告诉内核硬件长什么样。
    
2. **生成宏**：编译时，Zephyr 会读取设备树并生成一大堆以 `DT_` 开头的 C 宏。
    
3. **驱动绑定**：驱动程序通过 `compatible` 属性找到它要控制的硬件。
    

**结论：** C 代码通过宏来访问设备树，从而实现了“一套代码跑在不同板子上”。

---

### 3. 设备树覆盖 (Overlay) 的使用

你不需要修改 Zephyr 内置的板级 `.dts` 文件（那是系统级的）。如果你想改变某个引脚或关闭某个外设，你应该使用 **Overlay 文件**。

- **文件名**：通常命名为 `app.overlay` 或 `<board_name>.overlay`。
    
- **作用**：它会像“贴纸”一样覆盖在原始设备树上，修改或增加节点。
    

---

### 4. 练习：编写简单的 Overlay

假设我们在 QEMU 中运行，想临时**禁用**串口0（UART0），看程序会发生什么。

**操作步骤：**

1. 在你的项目根目录下（与 `prj.conf` 同级）新建一个文件：`app.overlay`。
    
2. 输入以下内容：
    
    Code snippet
    
    ```
    &uart0 {
        status = "disabled";
    };
    ```
    
3. **重新编译**：`west build -p always -b qemu_cortex_m3`。
    

**观察结果：**

你会发现 QEMU 启动后，终端**一片漆黑**。因为你通过设备树从“物理层面”关掉了输出窗口。

---

### 5. 设备树与驱动的关系：`DEVICE_DT_GET`

在 C 代码中，我们如何获取设备树描述的硬件？

C

```
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>

// 1. 从设备树获取标签为 uart0 的设备节点
#define UART0_NODE DT_NODELABEL(uart0)

int main(void) {
    // 2. 获取对应的设备结构体指针
    const struct device *dev = DEVICE_DT_GET(UART0_NODE);

    if (!device_is_ready(dev)) {
        // 驱动初始化失败
        return -1;
    }
    // 3. 现在你可以调用 UART 驱动接口了
}
```

---

### 📝 按照计划：今日总结

1. **Kconfig** 控制**代码**编不编译。
    
2. **DeviceTree** 控制**代码**去哪里找硬件。
    
3. **Overlay** 是你在不动内核源码的情况下，修改硬件定义的唯一合法手段。
    

**下一步任务建议：**

既然你学会了 Overlay，我们要不要尝试在设备树里定义一个**虚拟的 LED**（即使 QEMU 看不到灯亮），并在 C 代码里尝试去控制它的电平？这将打通你从“纯软件”到“底层驱动”的最后一公里。

**你想试试看在 Overlay 里“变”出一个 LED 来吗？**