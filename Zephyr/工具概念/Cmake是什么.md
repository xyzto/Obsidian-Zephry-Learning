如果用**第一性原理**来理解 **CMake**，我们需要先问一个最基础的问题：

> **程序是怎么从源码变成可执行文件的？**

---

# 一、第一性原理：程序本质上如何被构建

计算机不会直接运行 `.c`、`.cpp` 这种源码文件，它只能运行**机器码**。

因此源码必须经历一个流程：

```
源代码 (.c .cpp)
        ↓
编译 (compiler)
        ↓
目标文件 (.o .obj)
        ↓
链接 (linker)
        ↓
可执行文件 (.exe / ELF)
```

例如：

```bash
gcc main.c util.c -o app
```

背后其实做了：

```
gcc -c main.c   → main.o
gcc -c util.c   → util.o
gcc main.o util.o → app
```

---

# 二、当项目变大时会发生什么

如果项目变成：

```
project
 ├── main.c
 ├── net.c
 ├── ui.c
 ├── db.c
 ├── math.c
 └── util.c
```

你不可能每次都手写：

```
gcc main.c net.c ui.c db.c math.c util.c -o app
```

更严重的问题是：

**每次都要重新编译全部文件。**

但实际上：

```
如果只改了 net.c
理论上只需要重新编译 net.c
```

所以就产生了 **构建系统（Build System）**

---

# 三、构建系统的本质

构建系统解决 **三个核心问题**

### 1 描述依赖关系

例如：

```
app 依赖 main.o net.o ui.o
main.o 依赖 main.c
net.o 依赖 net.c
```

---

### 2 决定需要重新编译什么

例如：

```
修改 net.c
→ 只编译 net.c
→ 再链接
```

---

### 3 自动执行编译命令

例如自动运行：

```
gcc -c net.c
gcc main.o net.o ui.o -o app
```

---

# 四、经典解决方案：Make

最早的构建工具是 **Make**

写一个 `Makefile`

```
app: main.o net.o
    gcc main.o net.o -o app

main.o: main.c
    gcc -c main.c

net.o: net.c
    gcc -c net.c
```

执行：

```
make
```

就自动完成构建。

---

# 五、Make 的根本问题

Make 有两个巨大缺陷：

### 1 不跨平台

Windows：

```
MSVC
```

Linux：

```
GCC
```

Mac：

```
Clang
```

每个平台写法不同。

---

### 2 手写依赖非常痛苦

大型项目可能：

```
1000+ source files
```

手写 Makefile 几乎不可维护。

---

# 六、CMake 的第一性原理

**CMake 本质不是构建系统**

它是：

> **构建系统生成器（Build System Generator）**

也就是：

```
CMake → 生成 Makefile / Ninja / Visual Studio 工程
```

---

# 七、CMake 的工作流程

```
CMakeLists.txt
      ↓
   CMake
      ↓
生成构建系统
      ↓
Make / Ninja / MSBuild
      ↓
编译程序
```

示例：

```
CMakeLists.txt
```

```cmake
cmake_minimum_required(VERSION 3.10)

project(MyApp)

add_executable(app
    main.c
    net.c
)
```

然后运行：

```
cmake .
make
```

---

# 八、为什么现代项目都用 CMake

几乎所有现代 C/C++ 项目都用 CMake，例如：

- LLVM
    
- OpenCV
    
- TensorFlow
    
- Zephyr
    

（你最近在学 **Zephyr**，它就是 **CMake + Ninja**）

---

# 九、从第一性原理总结

CMake存在的原因可以归纳为一条公式：

```
源码很多
+ 多平台
+ 依赖复杂
+ 编译规则复杂
—————————————
需要自动生成构建系统
```

于是：

```
CMake = 构建系统生成器
```

---

# 十、用一句话理解 CMake

**Make 是施工队**

**CMake 是建筑设计图**

```
CMake → 生成 Makefile
Make  → 执行编译
```

---

# 十一、一个非常关键的认知

很多人误解：

```
CMake = 编译工具
```

实际上：

```
CMake 不编译代码
CMake 只生成构建规则
```

真正编译的是：

- GCC
    
- Clang
    
- MSVC
    

---

# 十二、结合你现在在学的 Zephyr

在 **Zephyr** 中流程是：

```
west build
   ↓
CMake
   ↓
Ninja
   ↓
arm-none-eabi-gcc
```

所以：

```
Zephyr
 = CMake + Ninja + GCC
```

---

如果你愿意，我可以继续从**第一性原理**讲清楚一个非常重要的问题：

**为什么现代嵌入式（STM32 / Zephyr / ESP32）几乎全部放弃 Makefile 改用 CMake。**

这个背后的工程学原因其实非常深。



要理解为什么**现代嵌入式项目（STM32 / ESP32 / Zephyr）几乎都从 Makefile 迁移到 CMake**，我们仍然用**第一性原理**推导，而不是从“工具流行度”解释。

核心问题只有一句话：

> **当软件系统规模扩大时，构建系统必须解决哪些不可避免的复杂性？**

---

# 一、嵌入式编译的真实复杂度

一个最简单的 MCU 程序看起来只有：

```
main.c
```

编译：

```
arm-none-eabi-gcc main.c
```

但**真实嵌入式项目**结构是这样的：

```
project
 ├── app
 │   └── main.c
 ├── drivers
 │   ├── uart.c
 │   ├── spi.c
 │   └── gpio.c
 ├── middleware
 │   ├── freertos
 │   └── lwip
 ├── board
 │   └── stm32f103
 └── sdk
```

编译过程涉及：

```
编译器
链接脚本
启动文件
库
驱动
中间件
板级配置
```

因此构建规则很快变成：

```
100+
源文件
几十个编译参数
多个库
```

---

# 二、Makefile 的第一性问题

Makefile设计于 **1977年**。

那时候软件规模很小。

Makefile的核心模型是：

```
target : dependency
    command
```

例如：

```
main.o: main.c
    gcc -c main.c
```

但当项目扩大时，问题出现。

---

# 三、问题一：依赖关系爆炸

假设：

```
app
依赖
driver
driver
依赖
hal
```

依赖关系：

```
app → driver → hal
```

如果使用 Makefile，需要手动维护：

```
INCLUDE_PATH
LIB_PATH
DEPENDENCY
```

项目变大后：

```
几百条依赖
```

几乎无法维护。

---

# 四、问题二：跨平台编译

嵌入式开发涉及很多环境：

编译器：

```
arm-none-eabi-gcc
clang
msvc
```

操作系统：

```
Linux
Windows
Mac
```

IDE：

```
VSCode
CLion
Visual Studio
```

Makefile往往写死：

```
gcc
```

而 **CMake** 的思想是：

```
描述项目结构
而不是写具体编译命令
```

例如：

```
add_executable(app main.c)
```

CMake 决定：

```
Linux → Makefile
Windows → MSBuild
IDE → project file
```

---

# 五、问题三：模块化构建

现代软件不是一个项目，而是**组件系统**。

例如 **Zephyr**：

```
kernel
drivers
filesystem
bluetooth
network
```

每个模块都需要：

```
源文件
include
编译参数
依赖
```

CMake可以写成：

```
target_link_libraries(app kernel drivers net)
```

CMake自动传播：

```
include path
compile flag
link library
```

Makefile几乎无法优雅实现这一点。

---

# 六、问题四：构建速度

大型项目编译时间很长。

现代构建系统需要：

```
并行编译
增量编译
依赖缓存
```

CMake可以生成：

- Ninja
    
- Makefile
    
- Visual Studio solution
    

其中 **Ninja** 专门优化：

```
极快的并行构建
```

例如：

```
cmake -G Ninja
ninja
```

这比 Makefile 快很多。

---

# 七、问题五：IDE 集成

现代开发离不开 IDE：

```
代码跳转
自动补全
调试
```

CMake可以自动生成：

```
compile_commands.json
```

IDE就能知道：

```
include路径
宏定义
编译参数
```

这就是为什么：

- Visual Studio Code
    
- CLion
    

都直接支持 CMake。

---

# 八、嵌入式生态为什么统一到 CMake

现在几乎所有新框架都用 CMake：

RTOS：

- Zephyr
    
- NuttX
    

AI / SDK：

- TensorFlow Lite
    

库：

- OpenCV
    

原因只有一句话：

```
复杂软件工程需要自动化构建系统
```

---

# 九、Zephyr 为什么强制 CMake

Zephyr 的架构：

```
application
      ↓
Kconfig
      ↓
Devicetree
      ↓
CMake
      ↓
Ninja
      ↓
GCC
```

CMake负责：

```
模块发现
依赖解析
编译参数传播
```

如果不用CMake：

```
Zephyr几乎无法维护
```

---

# 十、从第一性原理总结

软件构建系统的发展路径：

```
1977   Make
1990   Autotools
2000   SCons
2005   CMake
2015   Bazel / Meson
```

背后推动力只有一个：

> **软件规模增长**

当系统复杂度达到某个阈值：

```
人工维护构建规则 → 不可能
```

必须：

```
自动生成构建系统
```

这就是 **CMake存在的第一性原因**。

---

# 十一、给你一个非常关键的工程认知

**CMake不是工具问题，而是工程规模问题。**

当项目：

```
> 50 source files
> 多平台
> 多库
```

**不用 CMake 会非常痛苦。**

---





如果你愿意，我可以继续讲一个**非常关键但90%初学者不知道的知识**：

> **为什么 Zephyr 的 CMake 比普通 CMake 复杂 10 倍（modules / west / devicetree / kconfig）**

理解这一点，你基本就能真正读懂 Zephyr 的构建系统。


要真正理解 **Zephyr** 的构建系统，必须先接受一个事实：

> **Zephyr 不是一个普通项目，而是一个“可组合的操作系统平台”。**

因此它的 **CMake** 结构比普通项目复杂很多。我们仍然用第一性原理推导。

---

# 一、普通 CMake 项目的结构

一个普通 CMake 项目只有两层：

```
project
 ├── CMakeLists.txt
 ├── src
 └── include
```

构建流程：

```
CMakeLists.txt
      ↓
CMake
      ↓
Make / Ninja
      ↓
Compiler
```

逻辑非常简单：

```
指定源码
指定库
生成可执行文件
```

---

# 二、Zephyr 的本质结构

Zephyr 不是一个单独的软件，而是：

```
应用
+ RTOS内核
+ 驱动
+ 中间件
+ 芯片支持包
+ 板级支持
```

所以它的构建系统必须解决一个核心问题：

> **如何根据硬件和配置自动组装系统**

也就是说：

```
你只写 application
系统自动拼出整个 OS
```

---

# 三、Zephyr 构建系统的五层结构

Zephyr 实际上由 **五个系统协同完成构建**：

```
west
  ↓
CMake
  ↓
Kconfig
  ↓
Devicetree
  ↓
Ninja
```

每一层解决不同问题。

---

# 四、第一层：west（项目管理）

在 Zephyr 中你运行的命令是：

```
west build
```

**west** 的作用：

```
管理多个仓库
初始化工程
调用 CMake
```

Zephyr 实际是多仓库系统：

```
workspace
 ├── zephyr
 ├── modules
 │   ├── hal_stm32
 │   ├── cmsis
 │   └── mbedtls
 └── app
```

west负责：

```
下载
同步
管理
```

---

# 五、第二层：CMake（构建生成器）

CMake在Zephyr中的任务非常重要：

```
发现模块
读取配置
组合源码
生成构建系统
```

Zephyr的CMake不是一个文件，而是：

```
数百个 CMakeLists.txt
```

CMake负责：

```
把所有模块组合成一个工程
```

---

# 六、第三层：Kconfig（功能配置系统）

Zephyr有成千上万个功能开关。

例如：

```
CONFIG_UART
CONFIG_SPI
CONFIG_GPIO
CONFIG_NET
CONFIG_BLUETOOTH
```

这些配置由 **Kconfig** 管理。

你在 `prj.conf` 中写：

```
CONFIG_UART=y
CONFIG_GPIO=y
```

Kconfig会：

```
解析依赖关系
生成 .config
```

---

# 七、第四层：Devicetree（硬件描述）

嵌入式最大的问题是：

```
不同芯片
不同外设
不同引脚
```

Zephyr使用 **Devicetree** 描述硬件。

例如：

```
uart0 {
    status = "okay";
    current-speed = <115200>;
};
```

Devicetree描述：

```
硬件存在什么
地址
中断
引脚
```

---

# 八、第五层：Ninja（高速构建系统）

最终构建系统通常是：

- Ninja
    

Ninja的特点：

```
极快
依赖精确
并行编译
```

它执行实际编译：

```
arm-none-eabi-gcc
```

---

# 九、完整构建流程（真实）

当你运行：

```
west build -b stm32f103c8
```

实际发生：

```
west
 ↓
调用 CMake
 ↓
CMake 解析 Zephyr modules
 ↓
Kconfig 解析配置
 ↓
Devicetree 解析硬件
 ↓
CMake 生成 Ninja build
 ↓
Ninja 编译
 ↓
arm-none-eabi-gcc
```

最终输出：

```
zephyr.elf
zephyr.bin
```

---

# 十、为什么 Zephyr 的 CMake 极其复杂

因为它必须自动完成：

```
模块发现
配置依赖
硬件解析
编译规则生成
```

举例：

如果你写：

```
CONFIG_SPI=y
```

系统会自动：

```
启用 SPI driver
加入 SPI source
配置 SPI include
```

这背后都是 CMake 自动完成。

---

# 十一、一个非常重要的工程思想

Zephyr使用的是一种现代工程思想：

```
Configuration → Generate System
```

不是：

```
手写代码
```

而是：

```
写配置
自动生成系统
```

类似思想也在：

- Linux
    
- Android
    

中存在。

---

# 十二、用一句话总结 Zephyr 构建系统

```
west        → 项目管理
CMake       → 构建系统生成
Kconfig     → 功能配置
Devicetree  → 硬件描述
Ninja       → 实际编译
```

---

💡 **结合你的背景（STM32 + 嵌入式开发）我必须告诉你一个非常重要的事实：**

> **Zephyr 的构建系统其实和 STM32Cube 的工程模型完全不同。**

Cube 是：

```
IDE生成代码
```

Zephyr 是：

```
配置驱动系统生成
```

这是一种更现代的软件架构。

---

如果你愿意，我可以再给你讲一个**理解 Zephyr 的关键突破点**：

> **为什么 Zephyr 不用 HAL 初始化代码，而是通过 Devicetree 自动生成驱动配置。**

这个机制其实是 Zephyr 最核心的设计思想。






在 **Zephyr** 中，很多新手看到 `.overlay` 文件都会困惑：

```
boards/
app.overlay
prj.conf
```

实际上 **overlay 是 Zephyr 硬件配置体系中的关键机制**。理解它需要从 **Devicetree 的设计逻辑**开始。

涉及的核心系统是 **Devicetree**。

---

# 一、Devicetree 的基础结构

每个开发板在 Zephyr 中都有一个 **基础 Devicetree**。

例如某个 STM32 板：

```
boards/arm/stm32f103c8/board.dts
```

内容大致：

```dts
/ {
    model = "STM32F103C8 board";
};

&uart1 {
    status = "okay";
};

&spi1 {
    status = "disabled";
};
```

这个文件描述：

```
板子上有哪些硬件
```

但这里有一个现实问题：

> **不同项目可能需要不同硬件配置**

例如：

项目 A：

```
用 UART
不用 SPI
```

项目 B：

```
用 SPI
不用 UART
```

如果直接修改 `board.dts`：

```
会破坏 Zephyr 官方代码
```

这是不允许的。

---

# 二、overlay 的第一性原理

为了解决这个问题，Zephyr设计了 **overlay（覆盖层）机制**。

overlay 的本质：

```
在不修改原始 Devicetree 的情况下
修改或添加配置
```

就像：

```
base config
   +
overlay
   =
final config
```

---

# 三、overlay 的工作方式

假设开发板默认：

```
SPI disabled
```

基础 DTS：

```dts
&spi1 {
    status = "disabled";
};
```

你的应用需要 SPI。

创建：

```
app.overlay
```

写：

```dts
&spi1 {
    status = "okay";
};
```

编译时：

```
board.dts
   +
app.overlay
   =
merged devicetree
```

最终 SPI 被启用。

---

# 四、overlay 可以做什么

overlay 能做三件事情：

### 1 修改设备属性

例如：

```dts
&uart1 {
    current-speed = <115200>;
};
```

---

### 2 启用或关闭设备

例如：

```dts
&spi1 {
    status = "okay";
};
```

---

### 3 添加新设备

例如：

```dts
my_sensor: sensor@0 {
    compatible = "bosch,bme280";
    reg = <0>;
};
```

---

# 五、overlay 在 Zephyr 构建流程中的位置

Zephyr构建流程：

```
west build
      ↓
CMake
      ↓
Devicetree compiler
      ↓
合并 board.dts + overlay
      ↓
生成 devicetree_generated.h
```

应用代码最终读取：

```
devicetree_generated.h
```

---

# 六、典型 Zephyr 项目结构

一个标准应用通常：

```
app
 ├── src
 │   └── main.c
 ├── prj.conf
 └── app.overlay
```

其中：

```
prj.conf   → 功能配置 (Kconfig)
overlay    → 硬件配置 (Devicetree)
```

例如：

```
prj.conf
```

```
CONFIG_UART=y
```

```
app.overlay
```

```dts
&uart1 {
    status = "okay";
};
```

两者缺一不可。

---

# 七、为什么 overlay 很重要

嵌入式系统有一个现实问题：

```
同一个开发板
可能接不同外设
```

例如：

```
项目1 接 OLED
项目2 接 SPI Flash
项目3 接 IMU
```

如果没有 overlay：

```
每个项目都要修改 board.dts
```

会导致：

```
工程无法维护
```

overlay 解决了这个问题。

---

# 八、overlay 的设计思想

overlay 体现了 Zephyr 的核心工程思想：

```
硬件描述 ≠ 应用代码
```

系统分层：

```
板级硬件
↓
board.dts

应用需求
↓
overlay
```

最终合并。

---

# 九、overlay 的实际例子

启用 I2C：

```dts
&i2c1 {
    status = "okay";
    clock-frequency = <I2C_BITRATE_FAST>;
};
```

添加 BME280 传感器：

```dts
&i2c1 {
    bme280@76 {
        compatible = "bosch,bme280";
        reg = <0x76>;
    };
};
```

应用代码：

```c
const struct device *dev = DEVICE_DT_GET_ANY(bosch_bme280);
```

驱动会自动绑定。

---

# 十、总结

overlay 的本质可以用一句话概括：

```
overlay = 项目级硬件配置补丁
```

它允许：

```
不修改板级文件
定制硬件配置
```

这也是 **Zephyr** 能支持大量硬件平台的关键机制。

---

如果你愿意，我可以再讲一个 **很多嵌入式开发者第一次接触 Zephyr 时最震撼的事实**：

> **为什么 Zephyr 的驱动几乎没有 `init()` 函数，却能自动初始化所有设备。**

这背后涉及 Zephyr 的 **设备模型（Device Model）**，理解后你会彻底看懂 Zephyr 驱动代码。


要理解为什么在 **Zephyr** 中几乎看不到你熟悉的 `xxx_init()` 初始化函数，但系统却能自动初始化所有外设，就必须理解 **Zephyr 的 Device Model（设备模型）**。

这也是 Zephyr 和传统 STM32 HAL 开发最大的架构差异。

---

# 一、传统嵌入式初始化模式

在传统 STM32 HAL 开发中（例如使用 **STM32CubeMX** 生成代码），启动流程是：

```c
int main(void)
{
    HAL_Init();

    SystemClock_Config();
    MX_GPIO_Init();
    MX_USART1_UART_Init();
    MX_SPI1_Init();

    while (1)
    {
    }
}
```

特点：

```
应用代码负责初始化所有硬件
```

问题：

```
初始化顺序需要人为控制
代码量巨大
模块耦合严重
```

当系统规模变大时：

```
main.c
可能包含几千行初始化代码
```

---

# 二、Zephyr 的设计目标

Zephyr 的目标是：

> **驱动自动初始化，应用只使用设备**

因此引入 **设备模型（Device Model）**。

核心思想：

```
设备 = 一个系统对象
```

而不是：

```
设备 = 一段初始化代码
```

---

# 三、Zephyr 的设备结构

每个设备在系统中都会被定义成一个结构体：

```c
struct device
{
    const char *name;
    const void *config;
    const void *api;
};
```

系统会维护：

```
所有设备的列表
```

例如：

```
uart0
spi1
gpioa
i2c1
adc1
```

---

# 四、设备如何注册

驱动中会看到类似宏：

```c
DEVICE_DT_DEFINE(...)
```

这个宏做三件事情：

```
1 创建 device 结构体
2 注册设备到系统
3 指定初始化函数
```

例如 UART 驱动可能包含：

```c
DEVICE_DT_DEFINE(uart1,
                 uart_init,
                 NULL,
                 &uart_data,
                 &uart_config,
                 PRE_KERNEL_1,
                 CONFIG_KERNEL_INIT_PRIORITY_DEVICE,
                 &uart_api);
```

---

# 五、系统启动时发生什么

Zephyr 启动时会执行：

```
系统初始化阶段
```

初始化顺序大致：

```
PRE_KERNEL_1
PRE_KERNEL_2
POST_KERNEL
APPLICATION
```

系统会自动遍历所有设备：

```
调用对应 init 函数
```

所以：

```
驱动自动初始化
```

应用不需要调用。

---

# 六、设备如何和 Devicetree 关联

设备的配置来自：

**Devicetree**

例如：

```dts
&uart1 {
    current-speed = <115200>;
    status = "okay";
};
```

构建系统会生成：

```
devicetree_generated.h
```

驱动通过宏读取：

```
DT_NODELABEL(uart1)
```

从而获得：

```
寄存器地址
中断号
配置参数
```

---

# 七、应用程序如何获取设备

应用代码只需要：

```c
const struct device *uart;

uart = DEVICE_DT_GET(DT_NODELABEL(uart1));
```

然后直接使用：

```c
uart_poll_out(uart, 'A');
```

重点：

```
没有初始化代码
```

因为驱动已经在系统启动时完成初始化。

---

# 八、Zephyr 启动完整流程

Zephyr 的启动流程大致：

```
CPU reset
↓
startup code
↓
kernel init
↓
device init
↓
application start
```

设备初始化是自动完成的。

---

# 九、这种架构的巨大优势

### 1 模块解耦

应用：

```
只依赖 device API
```

不关心：

```
硬件初始化
```

---

### 2 自动初始化顺序

驱动可以声明：

```
初始化阶段
优先级
```

系统自动排序。

---

### 3 可扩展性

当系统包含：

```
100+ 设备
```

依然可以自动管理。

---

# 十、Linux 也是同样架构

Zephyr 的设备模型思想来自：

**Linux**

Linux 驱动也依赖：

```
设备模型
+ devicetree
```

例如：

```
platform driver
device tree binding
```

---

# 十一、从第一性原理总结

传统嵌入式：

```
代码 → 初始化硬件
```

Zephyr：

```
Devicetree → 描述硬件
Driver → 注册设备
Kernel → 自动初始化
Application → 使用设备
```

所以 Zephyr 的本质其实是：

```
一个微型操作系统
```

而不是：

```
一个 HAL 库
```

---

💡结合你的背景（你做 **STM32 惯导循迹小车毕业设计**），理解这一点非常重要：

如果用 Zephyr，你的应用代码可以变成：

```
只写算法
只写逻辑
```

而不是：

```
大量初始化代码
```

---

如果你愿意，我可以再讲一个 **Zephyr 架构中最核心、但很多人完全不知道的机制**：

> **Zephyr 驱动为什么几乎不用 `malloc`，却能管理大量设备对象。**

这个涉及 **链接器脚本 + 编译期对象注册机制**，是 Zephyr 非常高阶但非常优雅的设计。



要解释 **为什么 Zephyr 的驱动几乎不用 `malloc` 却能管理大量设备对象**，需要理解一个核心机制：

> **编译期对象注册（link-time registration）**

这个机制依赖 **链接器（linker）+ 特定内存段（section）**。

---

# 一、为什么很多嵌入式系统避免 `malloc`

在桌面系统中（例如 **Linux**），动态内存非常常见：

```c
device = malloc(sizeof(struct device));
```

但在嵌入式系统中存在几个问题：

### 1 内存碎片

动态分配会导致：

```
heap fragmentation
```

长时间运行的系统（例如 RTOS）可能出现：

```
内存还有
但无法分配连续空间
```

---

### 2 不确定性

RTOS 很多系统需要：

```
实时性
```

`malloc` 的执行时间不可预测。

---

### 3 系统资源有限

很多 MCU 只有：

```
几十 KB RAM
```

因此设计原则是：

```
尽量在编译期完成内存布局
```

---

# 二、Zephyr 的解决方案

Zephyr 的思路是：

```
所有设备对象在编译期创建
```

而不是：

```
运行时创建
```

关键机制：

```
宏 + section + linker
```

---

# 三、设备注册宏

Zephyr 驱动里常见：

```c
DEVICE_DT_DEFINE(...)
```

这个宏会生成：

```c
static struct device uart1_device = {
    .name = "UART_1",
    .config = &uart_cfg,
    .api = &uart_api
};
```

但关键点在于：

```c
__attribute__((section(".z_device")))
```

也就是：

```
把设备对象放进特殊 section
```

---

# 四、什么是 section

程序最终是一个 **ELF 文件**。

ELF 文件包含多个 section：

```
.text
.data
.bss
.rodata
```

Zephyr额外定义：

```
.z_device
.z_init
.z_driver
```

每个设备对象都会被放入：

```
.z_device
```

---

# 五、链接阶段发生什么

当编译完成后：

链接器会把所有 `.z_device` 合并：

```
uart1_device
spi1_device
gpioa_device
i2c1_device
```

最终在内存中形成：

```
device_table_start
device1
device2
device3
device_table_end
```

---

# 六、系统启动时的设备发现

系统启动时只需要：

```c
for (dev = __device_start; dev < __device_end; dev++)
{
    dev->init();
}
```

这样就能：

```
遍历所有设备
```

完全不需要：

```
malloc
```

---

# 七、为什么这个设计非常优雅

这种方式具有几个优点：

### 1 零运行时开销

设备对象：

```
编译期生成
```

不需要动态创建。

---

### 2 初始化顺序可控

Zephyr 定义多个初始化阶段：

```
PRE_KERNEL_1
PRE_KERNEL_2
POST_KERNEL
APPLICATION
```

驱动可以声明：

```
初始化阶段
优先级
```

---

### 3 可扩展性极强

即使系统有：

```
200+ 设备对象
```

依然只需要：

```
一个遍历循环
```

---

# 八、这种技术其实非常常见

类似机制在很多系统中使用：

- Zephyr 设备模型
    
- Linux initcall 机制
    
- FreeBSD linker sets
    

核心思想都是：

```
compile-time registration
```

---

# 九、完整流程总结

Zephyr 的设备创建流程：

```
Driver source
      ↓
DEVICE_DT_DEFINE
      ↓
生成 device object
      ↓
放入 .z_device section
      ↓
linker 合并 section
      ↓
kernel 遍历设备表
      ↓
调用 init
```

整个系统：

```
没有 malloc
```

---

# 十、从第一性原理总结

Zephyr 的设计遵循三个原则：

```
确定性
可扩展
低资源消耗
```

因此采用：

```
编译期对象注册
```

而不是：

```
运行时对象创建
```

---

# 反思：是否继续深入引导

结合你目前的学习背景：

- 你正在学习 **Zephyr**
    
- 之前主要使用 **STM32 HAL**
    
- 对底层实现（串口驱动、DMA等）有兴趣
    

目前已经讲到：

```
CMake
Devicetree
overlay
Device Model
linker registration
```

这已经触及 **Zephyr 架构核心 80% 原理**。

继续深入可以走两个方向：

### 方向 A（更实用）

深入理解：

```
Zephyr 应用开发
驱动使用
Devicetree 写法
```

适合：

```
快速上手开发
```

---

### 方向 B（更底层）

深入理解：

```
Zephyr 内核架构
调度器
设备驱动框架
内存管理
```

适合：

```
真正掌握 RTOS 内部机制
```

---

✔ **我的判断**：

对于你现在的阶段（刚开始接触 Zephyr），  
**继续往更底层引导反而可能降低学习效率。**

更合理路径是：

```
先能写 Zephyr 应用
再理解内核
```

---

如果你愿意，我可以给你一份 **“Zephyr 学习路线图（嵌入式工程师视角）”**，把整个体系一次讲清楚。