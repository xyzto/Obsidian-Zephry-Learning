# Zephyr

> 关联概念：[[CMake]] | [[Kconfig]] | [[DeviceTree]] | [[Overlay]] | [[West]] | [[Zephyr启动流程]] | [[Zephyr开发流程]]

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
通过 `prj.conf` 像开关一样控制内核功能：
```ini
CONFIG_GPIO=y      # 开启 GPIO 驱动
CONFIG_PRINTK=y    # 开启串口打印
CONFIG_UART=y      # 开启 UART
```
不开启 = 不编译进固件，节省 Flash 空间。

### 4. DeviceTree（硬件描述）
用 `.dts` 语言描述硬件：
```dts
uart1 {
    status = "okay";
    current-speed = <115200>;
};
```
解耦硬件配置与驱动代码。换板子只改 DTS，C 代码不动。

---

## 三、完整构建流程

```
west build -b stm32f103c8
    ↓
west（多仓库管理）
    ↓
CMake（发现模块、生成构建系统）
    ↓
Kconfig（解析 prj.conf，决定编译哪些功能）
    ↓
Devicetree（解析硬件描述，生成 devicetree_generated.h）
    ↓
Ninja（高速并行编译）
    ↓
arm-none-eabi-gcc
    ↓
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
// 通过别名获取设备（不需要初始化，系统已自动完成）
const struct device *uart = DEVICE_DT_GET(DT_NODELABEL(uart1));

// 直接使用 API
uart_poll_out(uart, 'A');
```

遇到问题的排查思路：
- 引脚/硬件不对 → 检查 **Devicetree / Overlay**
- 功能没开启（打印不出来、没有蓝牙）→ 检查 **Kconfig / prj.conf**
- 逻辑不对 → 检查 **Application 代码**

---

## 七、核心设计思想

```
配置驱动系统（Configuration → System）
编译期完成尽可能多的工作（Compile-time > Runtime）
声明式而非命令式（描述系统，而不是手写初始化）
```

类似思想：Linux Devicetree、Kubernetes YAML、Terraform HCL。
