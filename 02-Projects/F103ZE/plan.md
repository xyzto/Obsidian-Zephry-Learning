# Zephyr 学习计划 — F103ZE

> 目标：找嵌入式相关工作
> 硬件：STM32F103ZE 自制板
> 投入：2-3 小时 / 天
> 当前进度：Day11 完成，多线程基础掌握

---

## 整体思路

找工作不是学完功能清单，是能向面试官展示：
1. **我把 Zephyr 跑在了真实硬件上**（不是只会 QEMU）
2. **我能从头移植一块板子**（Board Bring-up 是嵌入式核心能力）
3. **我做过一个完整的项目**（传感器采集 + 多线程处理 + 串口输出）

三个阶段围绕这三件事展开，每阶段结束都有可以写进简历的产出。

---

## 第一阶段：硬件打通（Day12-Day16，约 5 天）

**目标：让 Zephyr 在你的 STM32F103ZE 板子上跑起来**

### Day12：Board Bring-up 前期准备

**任务：**
- 查原理图，记录以下信息（填入 env.md 引脚表）：
  - LED 接在哪个引脚
  - 串口调试用 USART1 还是 USART2，TX/RX 引脚号
  - 烧录方式（SWD/JTAG）
- 用 nucleo_f103rb 先跑一遍 `samples/basic/blinky`，确认工具链正常

**验证标准：** nucleo_f103rb 下 blinky 编译烧录成功

---

### Day13：创建自定义 Board

**任务：**
- 基于 `stm32f103_mini` 创建 `my_f103ze` board
- 修改 Flash（512KB）和 RAM（64KB）大小
- 配置 USART 和 LED 引脚

**参考：** [[05-Questions/如何为STM32F103ZE创建自定义Board]]

**验证标准：** `west build -b my_f103ze samples/basic/blinky` 编译通过

---

### Day14：第一次烧录上真实硬件

**任务：**
- 烧录 blinky，看灯是否按预期闪烁
- 烧录 `samples/hello_world`，通过串口看到输出

**验证标准：** 串口打印出 `Hello World`，LED 闪烁正常

**遇到问题记录到：** `lab/01-board-bringup.md`

---

### Day15：GPIO 驱动深入

**任务：**
- 实现按键输入（GPIO 中断模式，不用轮询）
- 按键按下 → LED 翻转，通过中断触发而非主循环检测

**验证标准：** 按键中断触发，LED 响应，串口打印中断计数

---

### Day16：阶段总结

**任务：**
- 把 board 移植过程写成 `lab/01-board-bringup.md`
- 把 GPIO 中断实验写成 `lab/02-gpio-interrupt.md`
- 更新 `05-Questions/如何为STM32F103ZE创建自定义Board.md` 状态为 ✅

**阶段产出（可写进简历）：**
> 基于 STM32F103ZE 完成 Zephyr RTOS Board 移植，包含 DTS 配置、内存布局修改和外设适配

---

## 第二阶段：外设驱动（Day17-Day26，约 10 天）

### Day17-18：UART 驱动

**要掌握的：** 中断接收 / 异步收发 / 环形缓冲区

**实验：** 串口命令解析器，接收 `led on` / `led off` 控制 LED

**新建 Concept：** `01-Concepts/UART.md`

---

### Day19-20：I2C 驱动

**要掌握的：** `i2c_write_read()` / 从设备树获取 I2C 设备 / 读取真实传感器

**新建 Concept：** `01-Concepts/I2C.md`

---

### Day21-22：SPI 驱动

**要掌握的：** `spi_transceive()` / SPI 设备树配置

**新建 Concept：** `01-Concepts/SPI.md`

---

### Day23-24：驱动框架理解

**任务：** 阅读 `gpio_stm32.c`，理解 `DEVICE_DT_DEFINE` 和 `compatible` 绑定机制

**验证标准：** 能用自己的话解释"为什么 Zephyr 不需要手动调用 UART_Init()"

---

### Day25-26：外设阶段综合实验

**实验：** 多传感器 + 多线程数据采集系统（I2C 采集 → 消息队列 → 处理线程 → 告警）

**阶段产出（可写进简历）：**
> 基于 Zephyr RTOS 实现多传感器数据采集系统，涵盖 UART/I2C/SPI 驱动开发及多线程协同处理

---

## 第三阶段：完整项目（Day27-Day35，约 9 天）

### 项目选择（选一个）

**选项 A：环境监测节点**（偏物联网）
- I2C 读温湿度 / UART 上报 / 低功耗设计 / 按键切换采样频率

**选项 B：电机控制基础**（偏工业控制）
- PWM 控速 / 编码器读转速 / PID 闭环 / 串口显示

**选项 C：自定义串口协议**（偏通信协议）
- 帧协议设计 / DMA + 中断接收 / 环形缓冲区管理

---

### Day27-28：项目设计

画出软件架构图，写出 `lab/project-[名称].md`，记录设计决策。

### Day29-32：项目实现

每天记录：今天实现了什么 / 遇到了什么问题 / 怎么解决的。

### Day33-34：调试和优化

- `west build -t ram_report` 查看内存占用
- 检查线程栈大小是否合理

### Day35：项目总结

- 完善 `lab/project-[名称].md`
- 推到 GitHub，写好 README
- 更新 `progress.md`

**阶段产出（可写进简历）：**
> 独立设计并实现基于 Zephyr RTOS 的 [项目名]，完成从 Board 移植、驱动开发到应用逻辑的全栈开发

---

## 面试准备（穿插在学习过程中）

**RTOS 基础**：信号量 vs Mutex / 优先级翻转 / 栈溢出排查 / k_msleep vs delay

**Zephyr 特有**：Devicetree 解决什么问题 / 驱动绑定机制 / 电源管理

**项目相关**：线程架构为什么这样设计 / 遇到过什么问题 / 内存占用是多少
