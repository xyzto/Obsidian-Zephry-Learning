好的，井野！今天（第1周 Day 1–2 的核心任务）我们来系统完成你列的5个学习点。这些内容是 Zephyr 构建系统的**最基础基石**，理解透彻后，后续改配置、加外设、写驱动都会顺很多。

我会按你列的顺序一条一条讲清楚：**是什么 + 为什么重要 + 关键规则/写法 + 简单示例 + 动手验证建议**（全部用 QEMU 测试，零硬件）。

### 1. 理解 Zephyr 的项目组织结构
<mark style="background: #ADCCFFA6;"></mark>
Zephyr 应用是**“以应用为中心”**的构建系统（<mark style="background: #ADCCFFA6;">*application-centric*</mark>），不像传统嵌入式项目把内核和应用混在一起。The request is not authorized because credentials are missing or invalid.

**典型最小项目目录结构**（官方推荐）：

```
my_app/                  ← 你的应用根目录（可以随便命名）
├── CMakeLists.txt       ← 必须有，CMake 入口
├── prj.conf             ← 通常有，应用专属 Kconfig 配置（可以空）
├── app.overlay          ← 常见可选，应用专属 Devicetree 修改（overlay）
├── src/                 ← 推荐放源代码的子目录
│   └── main.c           ← 你的主程序
└── build/               ← west build 自动生成（不要手动改）
    └── zephyr/          ← 最终 .config、zephyr.elf、zephyr.dts 等都在这里
```

- **src/**：放你的 .c/.cpp 文件（官方推荐这样组织，便于扩展）
- **build/**：out-of-source build，干净隔离
- 可选扩展：boards/（自定义板）、Kconfig（自定义选项）、include/ 等

**为什么这样设计？**  
让应用代码与 Zephyr 内核分离，便于复用、升级内核、做多应用项目。

**动手验证**（今天必做）：
- 在你的 zephyrproject 外新建文件夹 `~/my_first_app`
- 里面创建上面结构（src/main.c 可以先空着）
- 复制 samples/hello_world 的 CMakeLists.txt + prj.conf 过来
- 运行 `west build -b qemu_cortex_m3 .` （注意点在当前目录）
- 成功 → 说明你已经能自己建最小项目了

### 2. 学习 CMakeLists.txt 文件的编写规则

CMakeLists.txt 是 Zephyr 构建的**真正入口**（west build 本质调用 CMake）。

**最简写法**（几乎所有应用都这样开头）：

```cmake
# 最低 CMake 版本（Zephyr 推荐 3.20+）
cmake_minimum_required(VERSION 3.20.0)

# 加载 Zephyr 的 CMake 模块（必须）
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})

# 可选：给项目起个名字（不影响构建，但好看）
project(my_first_app)

# 把你的源文件加到 "app" 这个目标里（Zephyr 预定义的）
target_sources(app PRIVATE
    src/main.c
    # src/other.c  # 可以加多个
)
```

**常见额外写法**（后期会用到）：

- 指定板子（如果不靠 west -b 传）：
  ```cmake
  set(BOARD qemu_cortex_m3)
  ```

- 加 Devicetree overlay：
  ```cmake
  set(DTC_OVERLAY_FILE "app.overlay")
  ```

- 加多个 conf 文件：
  ```cmake
  set(CONF_FILE "prj.conf" "extra.conf")
  ```

- 创建子库（模块化）：
  ```cmake
  zephyr_library_named(my_utils)
  target_sources(my_utils PRIVATE src/utils.c)
  target_link_libraries(app PRIVATE my_utils)
  ```

**规则总结**：
- 必须先 `find_package(Zephyr ...)` 才能用 Zephyr 专有命令
- 源文件统一加到 `app` target（PRIVATE 就够）
- 不要自己写 `add_executable()`，Zephyr 已经帮你处理

**动手**：在你的 my_first_app 里写上面最简 CMakeLists.txt → west build -b qemu_cortex_m3 → 看 build/zephyr/zephyr.map 是否有你的 main.c

### 3. 了解 prj.conf 配置文件的作用

prj.conf 是**应用层 Kconfig 片段**（fragment），用来覆盖/启用内核或驱动的配置选项。

**作用**：
- 决定“开不开”某个功能（e.g. logging、shell、Bluetooth）
- 设置数值（e.g. 线程栈大小、tick 频率）
- 合并顺序：板子默认 → SoC 默认 → 你的 prj.conf → 命令行 > prj.conf 优先级最高

**写法示例**（最常用）：

```
# 启用日志（推荐开发期开）
CONFIG_LOG=y
CONFIG_LOG_DEFAULT_LEVEL=4   # 4=DEBUG

# 启用 shell（超级好用）
CONFIG_SHELL=y
CONFIG_KERNEL_SHELL=y

# 改 tick 频率（影响调度精度）
CONFIG_SYS_CLOCK_TICKS_PER_SEC=1000

# 启用 C++（如果用）
CONFIG_CPP=y
```

**空文件也行**（默认用板子配置），但建议至少放一行注释。

**动手**：新建 prj.conf 写入上面 3 行 → west build → west build -t menuconfig 检查是否生效（搜索 LOG、SHELL）

### 4. 掌握 west build 命令的使用方法

west build 是日常最常用的命令（封装了 CMake + make/ninja）。

**最常用格式**：

```bash
west build -b <板子名> [应用路径] [选项]
```

**例子**（今天练这些）：

- 基本构建（当前目录）：
  ```bash
  west build -b qemu_cortex_m3
  ```

- 指定路径（推荐）：
  ```bash
  west build -b qemu_cortex_m3 ~/my_first_app
  ```

- 运行/调试：
  ```bash
  west build -t run       # QEMU 自动跑
  west build -t debug     # 进 gdb
  ```

- 清理：
  ```bash
  west build -t clean
  west build -t pristine  # 彻底清（改大配置时用）
  ```

- 改配置不重新写 CMake：
  ```bash
  west build -t menuconfig   # 图形改 Kconfig
  west build -t guiconfig    # 图形改（如果装了）
  ```

- 传额外 CMake 参数（高级）：
  ```bash
  west build -b qemu_cortex_m3 -- -DOVERLAY_CONFIG=app.overlay
  ```

**动手**：用上面所有 -t 选项各跑一次，看输出差异

### 5. 学习设备树（Devicetree）的基本概念

Devicetree（DT）是**描述硬件的文本树结构**（不是代码），Zephyr 用它来“知道”板子上有什么外设、引脚怎么接。

**核心概念**（今天记住这几点就够）：

- **.dts**：板子级硬件描述（e.g. nrf52840dk_nrf52840.dts）
- **.overlay**：应用/自定义修改（叠加在板子 .dts 上）
- **节点**：硬件单元（e.g. uart0: uart@40002000 { … }）
- **属性**：节点里的 key = value（e.g. status = "okay"; gpios = <&gpio0 13 0>;）
- **compatible**：驱动匹配字符串（e.g. "gpio-leds"）
- **生成头文件**：build 时自动生成 devicetree_generated.h，代码用 DT_ 开头的宏访问（e.g. DT_NODELABEL(uart0)）

**最简单 overlay 示例**（app.overlay）：

```dts
/ {
    chosen {
        zephyr,console = &uart0;   // 指定哪个 uart 是 console
        zephyr,shell-uart = &uart0;
    };

    leds {
        compatible = "gpio-leds";
        my_led: led_0 {
            gpios = <&gpio0 13 GPIO_ACTIVE_HIGH>;
            label = "My LED";
        };
    };
};
```

**动手**：在 my_first_app 创建 app.overlay 写入上面内容 → west build -b qemu_cortex_m3 → 检查 build/zephyr/zephyr.dts 是否包含你的 leds 节点

### 今天小结 & 自测清单

- [ ] 自己建一个空项目目录 + CMakeLists.txt + prj.conf
- [ ] west build -b qemu_cortex_m3 成功（哪怕 main.c 是空的）
- [ ] menuconfig 里能看到你 prj.conf 的配置
- [ ] west build -t run 看到 QEMU 启动（即使没输出）
- [ ] 理解 west build / CMake / prj.conf / overlay 的关系

完成这些后，回复我“今天任务完成” + 任何疑问/报错截图，我们明天继续第1周后半（跑 samples + 改 overlay 练习）。

有任何一步卡住，直接贴终端输出，我马上帮 debug。  
今天加油！这些基础打好，后面线程、外设、无线都会轻松很多～