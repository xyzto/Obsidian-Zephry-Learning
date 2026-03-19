# CMake

> 关联概念：[[Zephyr]] | [[West]] | [[Kconfig]] | [[DeviceTree]]

## 一、第一性原理：程序是怎么从源码变成可执行文件的？

```
源代码 (.c .cpp)
        ↓ 编译 (compiler)
目标文件 (.o .obj)
        ↓ 链接 (linker)
可执行文件 (.exe / ELF)
```

## 二、CMake 的本质

**CMake 不是编译器，不是构建工具，而是：**

> **构建系统生成器（Build System Generator）**

```
CMakeLists.txt
      ↓ CMake
生成构建系统（Makefile / Ninja / Visual Studio）
      ↓ Make / Ninja
编译程序（GCC / Clang / MSVC）
```

用一句话记住：**Make 是施工队，CMake 是建筑设计图。**

---

## 三、为什么需要 CMake（构建系统的演进）

| 时代 | 工具 | 问题 |
|------|------|------|
| 1977 | Make | 不跨平台，手写依赖痛苦 |
| 1990 | Autotools | 配置复杂 |
| 2005 | CMake | 跨平台，自动管理依赖 |
| 2015 | Bazel/Meson | 超大型项目 |

**Make 的两大根本缺陷：**
1. 不跨平台：Windows 用 MSVC，Linux 用 GCC，Mac 用 Clang，每个平台写法不同
2. 手写依赖极其痛苦：1000+ 源文件的项目几乎不可维护

**CMake 的解决方案：**
- 描述项目结构，而不是写具体编译命令
- `add_executable(app main.c net.c)` → CMake 决定用什么工具链
- `target_link_libraries(app kernel drivers net)` → 自动传播 include path、编译参数、链接库

---

## 四、CMake 解决的五个核心问题

| 问题 | CMake 的方案 |
|------|-------------|
| 依赖关系爆炸 | 自动解析模块依赖 |
| 跨平台编译 | 生成对应平台的构建系统 |
| 模块化构建 | `target_link_libraries` 自动传播 |
| 构建速度 | 生成 Ninja（专为并行编译优化） |
| IDE 集成 | 自动生成 `compile_commands.json` |

---

## 五、Zephyr 中的 CMake

在 Zephyr 中，完整构建链是：

```
west build
    ↓ west（项目管理）
CMake
    ↓ 解析模块、读取配置
Kconfig → 功能配置
    ↓
Devicetree → 硬件描述
    ↓
Ninja（高速构建）
    ↓
arm-none-eabi-gcc
    ↓
zephyr.elf / zephyr.bin
```

Zephyr 的 CMake 比普通项目复杂 10 倍，因为它必须自动完成：
- **模块发现**：扫描 zephyr/、modules/ 下的所有组件
- **配置依赖**：`CONFIG_SPI=y` → 自动加入 SPI 驱动源码和 include
- **硬件解析**：从 Devicetree 生成 `devicetree_generated.h`
- **编译规则生成**：最终产出 Ninja build 文件

---

## 六、关键认知

```
CMake 不编译代码
CMake 只生成构建规则
真正编译的是 GCC / Clang / MSVC
```

当项目达到以下规模，不用 CMake 会非常痛苦：
- 超过 50 个源文件
- 多平台支持
- 多个依赖库

---

## 七、现代嵌入式为什么从 Makefile 迁移到 CMake

嵌入式真实项目的复杂度：
```
drivers/uart.c + drivers/spi.c + middleware/freertos/ + board/stm32f103/ + sdk/
```

这要求构建系统具备：依赖管理、跨平台、模块化、高速并行构建、IDE 集成。

**Makefile 设计于 1977 年，不具备以上能力。CMake 是答案。**

使用 CMake 的主流项目：LLVM、OpenCV、TensorFlow、**Zephyr**。
