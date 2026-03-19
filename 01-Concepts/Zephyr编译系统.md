# Zephyr 编译系统

> 关联概念：[[CMake]] | [[Kconfig]] | [[DeviceTree]] | [[Zephyr]]

## 一、全局构建链

Zephyr 构建的本质是**元编程（Meta-programming）**——在你按下编译键的那一刻，系统现场为你组装出一套定制操作系统。

```
west build
    ↓
CMake（第一、二阶段：组织 + 生成）
    ↓
Ninja（第三、四阶段：编译 + 链接）
    ↓
zephyr.bin
```

---

## 二、四个构建阶段

### 第一阶段：配置合并（Configuration Phase）

CMake 和 Python 脚本将分散在各处的配置汇总：

1. **硬件合并**：`board.dts`（出厂设置）+ `app.overlay`（你的改动）→ 最终 `zephyr.dts`
2. **软件合并**：`prj.conf` + 内核默认配置 → `.config`（最终开关清单）

产出：`build/zephyr/.config`

### 第二阶段：代码生成（Source Generation Phase）

根据第一阶段的硬件描述，自动生成 C 语言宏定义：

- 例：你在 DTS 里定义了 `led0` 在 PB12，系统自动生成 `DT_N_S_leds_S_led_0_P_gpios_...` 宏
- 产出：`build/zephyr/include/generated/devicetree_generated.h`
- 意义：C 代码无需硬编码地址，直接通过 `DT_*` 宏访问硬件

### 第三阶段：静态编译（Compilation Phase）

1. **条件编译**：根据 `.config` 的开关决定哪些 `.c` 参与编译（没开蓝牙 → 蓝牙驱动代码被彻底忽略）
2. **编译**：GCC/LLVM 将所有选中的 `.c` 编译为 `.o` 目标文件

### 第四阶段：链接与内存布局（Linking Phase）

1. **链接脚本**：根据芯片的 Flash 和 RAM 大小自动生成链接脚本
2. **符号解析**：将内核函数、驱动函数、你的 `main` 函数缝合在一起
3. 产出：`zephyr.elf`（带调试信息）和 `zephyr.bin`（纯二进制）

---

## 三、阶段总结表

| 步骤 | 输入 | 处理工具 | 输出 |
|------|------|---------|------|
| 1. 硬件合并 | `.dts` + `.overlay` | DeviceTree Compiler | 最终 `zephyr.dts` |
| 2. 功能配置 | `prj.conf` + Kconfig | Kconfig Python Scripts | `.config` |
| 3. 代码生成 | `zephyr.dts` + `.config` | Zephyr Python Tools | `devicetree_generated.h` |
| 4. 编译链接 | 头文件 + `.c` 源码 | GCC + Ninja | `zephyr.bin` |

---

## 四、亲眼验证构建产物

构建后可以翻看这些文件加深理解：

```bash
# 查看从 DTS 生成的宏
build/zephyr/include/generated/devicetree_generated.h

# 查看最终功能配置（是否真的开启了你想要的 CONFIG）
build/zephyr/.config

# 查看合并后的完整设备树
build/zephyr/zephyr.dts
```

> 技巧：在 `.config` 里搜索你在 `prj.conf` 里写的 `CONFIG_XXX`，如果看到 `=n` 说明依赖没满足。
