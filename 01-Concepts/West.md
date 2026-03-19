# West

> 关联概念：[[CMake]] | [[Zephyr]] | [[Zephyr开发流程]]

## 一、本质

West 是 Zephyr 的**多仓库管理工具 + 构建入口**。

Zephyr 不是一个单仓库项目，而是由 zephyr 核心 + 数十个 modules（hal_stm32、cmsis、mbedtls 等）组成的多仓库系统。West 负责统一管理这些仓库，并作为构建命令的统一入口。

```
west build
    ↓ 调用
CMake + Ninja
    ↓
编译出 zephyr.bin
```

---

## 二、核心命令

### 构建
```bash
west build -b <board>                    # 基本构建
west build -b <board> -p always          # 强制清理缓存重编（改了 overlay/conf 必用）
west build -b <board> -- -DOVERLAY_CONFIG=extra.conf  # 传额外参数
```

### 运行与烧录
```bash
west build -t run        # QEMU 仿真运行
west flash               # 烧录到真实硬件（自动调用 OpenOCD/J-Link）
west build -t debug      # 启动 GDB 调试
```

### 配置
```bash
west build -t menuconfig   # 图形化 Kconfig 界面（按 / 搜索）
west build -t guiconfig    # GUI 版 menuconfig
```

### 仓库管理
```bash
west update               # 同步所有子仓库到 west.yml 指定版本
west boards               # 列出所有支持的开发板
west config -l            # 查看当前环境配置
```

---

## 三、何时必须加 `-p always`

以下情况必须加，否则编译可能使用旧缓存：

- 修改了 `app.overlay`
- 修改了 `prj.conf` 中的关键配置
- 换了 `-b` 目标板
- 移动了项目目录
- 遇到莫名其妙的编译错误时

```bash
west build -p always -b qemu_cortex_m3
```

---

## 四、多仓库结构

West 管理的工作区结构：

```
zephyr-workspace/
├── .west/              # west 配置
├── zephyr/             # Zephyr 核心（主仓库）
├── modules/
│   ├── hal_stm32/
│   ├── cmsis/
│   └── mbedtls/
└── my_app/             # 你的应用（独立于 Zephyr 源码）
```

**应用代码永远放在 Zephyr 源码目录之外**，通过 `west build` 指定路径编译。
