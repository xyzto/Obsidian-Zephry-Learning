# GDB

> 关联概念：[[01-Concepts/Zephyr开发流程]] | [[01-Concepts/QEMU]]
> 来源问题：[[]]

## 本质

GNU Debugger，程序运行时的"显微镜 + 控制器"。核心能力一句话：让你在程序运行时停下来、看内部、改状态、再继续。

## 解决什么问题

- 精确定位 bug（段错误、除零、死锁），而不是靠猜
- 分析复杂运行时行为：中断触发顺序、多线程竞争、栈溢出
- 替代"printf 调试"，直接查看寄存器、内存、调用栈

## 核心机制

四类能力：

**控制执行流**：`step`（进函数）/ `next`（不进函数）/ `continue`（运行到下一断点）

**断点**：`break <函数名或行号>`，条件断点 `break ... if <条件>`

**查看状态**：`print <变量>`、`x/<格式> <地址>`（内存）、`info registers`、`backtrace`

**修改状态**：`set var <变量>=<值>`，强行改变执行路径

## 与相关概念的区别

| | GDB | IDE 调试按钮 |
|---|---|---|
| 本质 | 调试引擎本身 | GDB 的图形壳 |
| 灵活性 | 完整控制 | 受 UI 限制 |
| 嵌入式场景 | 必须会 | 依赖工具链配置 |

## 在 Zephyr 里怎么用

**QEMU 调试**：
```bash
# 终端1：启动 QEMU 等待 GDB 连接
west build -t debugserver

# 终端2：连接
gdb-multiarch build/zephyr/zephyr.elf
(gdb) target remote :1234
(gdb) break main
(gdb) continue
```

**STM32 实板**（配合 OpenOCD）：
```bash
# 终端1
openocd -f interface/stlink.cfg -f target/stm32f1x.cfg

# 终端2
arm-zephyr-eabi-gdb build/zephyr/zephyr.elf
(gdb) target remote :3333
(gdb) monitor reset halt
(gdb) break main
(gdb) continue
```

**Zephyr 特有**：可查看线程切换、各线程栈使用、内核对象状态。

## 坑

**现象**：QEMU 调试时连接 GDB 后无响应
**原因**：需先 `west build -t debugserver` 启动监听，再另开终端连接
**解决**：两个终端分开跑，顺序不能反

## 产生的问题

→ [[05-Questions/问题名]]

## 验证记录

→ [[02-Projects/QEMU/lab/实验文件名]]
