# QEMU

> 关联概念：[[Zephyr]] | [[West]] | [[Zephyr开发流程]]

## 一、本质

QEMU 是一个**软件模拟计算机引擎**，用软件实现 CPU、内存、外设的完整行为。

```
你的 ARM 程序
    ↓
QEMU（用软件模拟 ARM CPU）
    ↓ 动态二进制翻译（DBT）
在 x86 电脑上执行
```

在 Zephyr 开发中的价值：**不需要真实硬件就能编译、运行、调试固件。**

---

## 二、QEMU vs 虚拟机

| 类型 | 工具 | 本质 |
|------|------|------|
| 虚拟机（硬件辅助） | VMware / VirtualBox | 运行同架构系统，依赖 CPU 虚拟化指令 |
| 模拟器（软件翻译） | QEMU | 用软件翻译指令，可跨架构 |

QEMU 可以在 x86 电脑上完整模拟 ARM Cortex-M3，包括寄存器、中断控制器、UART 等外设。

---

## 三、在 Zephyr 中的使用

```bash
# 构建并运行（最常用）
west build -b qemu_cortex_m3 samples/hello_world
west build -t run

# 退出 QEMU
Ctrl + A → 然后按 X
```

运行后终端会显示：
```
Hello World! qemu_cortex_m3
```

---

## 四、QEMU 调试（比真板子更强）

```bash
# 启动 GDB 调试会话
west build -t debug
```

QEMU 调试优势：
- 单步执行，观察每条指令
- 查看所有寄存器状态
- 设置断点、观察内存
- 不怕烧坏硬件
- 可以随时暂停、回溯

---

## 五、常用 QEMU 目标板

| 目标板名 | 对应硬件 | 用途 |
|---------|---------|------|
| `qemu_cortex_m3` | ARM Cortex-M3 | 通用 Zephyr 功能验证 |
| `qemu_cortex_m0` | ARM Cortex-M0 | 最小 ARM 架构测试 |
| `qemu_x86` | x86 | 非嵌入式场景测试 |
| `native_sim` | 本机 Linux 进程 | 最快，适合单元测试 |

---

## 六、局限性

QEMU 不能完全替代真实硬件：
- **外设不完整**：某些特定芯片外设没有对应模拟
- **时序不准确**：时钟、定时器精度与真实硬件有差异
- **外部信号**：无法模拟真实传感器、物理电气信号

**流程建议**：先用 QEMU 验证逻辑 → 再上真实硬件验证时序和外设。
