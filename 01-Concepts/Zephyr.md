# Zephyr

> 关联概念：[[CMake]] | [[Kconfig]] | [[DeviceTree]] | [[Overlay]] | [[West]] | [[Zephyr启动与设备初始化]] | [[Zephyr开发流程]] | [[Zephyr编译系统]]

## 一、Zephyr 是什么

Zephyr 不是一个 HAL 库，而是一个**可组合的嵌入式操作系统平台**。

| 对比维度 | STM32 HAL | Zephyr |
|---------|-----------|--------|
| 硬件配置 | 代码初始化 | Devicetree 描述 |
| 功能配置 | 手写宏 | Kconfig |
| 初始化 | 手动调用 `xxx_Init()` | 自动 |
| 驱动 | 与板级耦合 | 通用 API |
| 系统结构 | 单程序（裸机/库） | RTOS 操作系统 |

---

## 二、四大核心部件

### 1. Application（业务逻辑层）
你写 `.c` 代码的地方。代码是**平台无关**的——你不需要管 LED 接在哪个引脚，只需要告诉系统"我要操作名为 `led0` 的设备"。

### 2. Kernel（内核层）
负责多线程调度、信号量（Semaphore）、消息队列（Queue）、定时器等。是连接应用层和底层硬件的"大脑"。

### 3. Kconfig（功能配置）
通过 `prj.conf` 像开关一样控制内核功能。详见 [[Kconfig]]。

### 4. DeviceTree（硬件描述）
用 `.dts` 语言描述硬件，解耦硬件配置与驱动代码。详见 [[DeviceTree]] 和 [[Overlay]]。

---

## 三、构建流程

完整构建链详见 [[Zephyr编译系统]]。简要概述：

```
west build
    ↓ West → CMake → Kconfig → DeviceTree → Ninja → GCC
zephyr.elf / zephyr.bin
```

---

## 四、五层架构

```
Application（业务逻辑）
    ↓
Subsystems / Middleware（蓝牙、网络、文件系统）
    ↓
Kernel（线程、调度、IPC）
    ↓
Device Drivers（GPIO、UART、SPI、I2C）
    ↓
Architecture（ARM、RISC-V、x86 适配）
```

**Devicetree + Kconfig + CMake** 贯穿所有层级，负责生成整个系统。

---

## 五、Zephyr 源码目录结构

| 目录 | 角色 | 内容 |
|------|------|------|
| `arch/` | CPU 适配层 | 线程切换、中断处理、汇编启动代码 |
| `boards/` | 开发板支持 | board.dts、Kconfig.board |
| `drivers/` | 设备驱动 | gpio/、uart/、spi/、i2c/、sensor/ |
| `dts/bindings/` | Devicetree 规则 | 定义每种设备的属性格式（YAML） |
| `kernel/` | RTOS 内核 | thread.c、sched.c、mutex.c |
| `subsys/` | 子系统 | bluetooth/、net/、fs/、usb/ |
| `include/zephyr/` | 公共 API | device.h、kernel.h |
| `samples/` | 官方示例 | 学习入口 |

**推荐阅读顺序：** `samples/basic/` → `drivers/gpio/` → `kernel/` → `arch/`

---

## 六、应用程序如何使用设备

```c
// 通过标签获取设备（不需要初始化，系统已自动完成）
const struct device *uart = DEVICE_DT_GET(DT_NODELABEL(uart1));

// 直接使用 API
uart_poll_out(uart, 'A');
```

排查思路：
- 引脚/硬件不对 → 检查 [[DeviceTree]] / [[Overlay]]
- 功能没开启 → 检查 [[Kconfig]]
- 设备未初始化 → 检查 [[Zephyr启动与设备初始化]]
- 逻辑不对 → 检查 Application 代码

---

## 七、核心设计思想

```
配置驱动系统（Configuration → System）
编译期完成尽可能多的工作（Compile-time > Runtime）
声明式而非命令式（描述系统，而不是手写初始化）
```

类似思想：Linux Devicetree、Kubernetes YAML、Terraform HCL。
