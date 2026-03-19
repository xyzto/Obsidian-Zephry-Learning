# Kconfig

> 关联概念：[[Zephyr]] | [[CMake]] | [[DeviceTree]] | [[Zephyr编译系统]]

## 一、本质

Kconfig 是 Zephyr 的**功能开关系统**，控制哪些代码被编译进固件。

```
你写 prj.conf（开关清单）
    ↓ Kconfig 解析
.config（最终配置）
    ↓ 生成
autoconf.h（C 语言宏）
    ↓ 条件编译
只有被开启的功能才进入固件
```

不开启 = 代码根本不参与编译，节省 Flash 和 RAM。

---

## 二、三层结构

| 层 | 文件 | 作用 |
|----|------|------|
| 定义层 | `Kconfig` 文件（Zephyr 源码里） | 规定"有哪些开关可以拨" |
| 配置层 | `prj.conf`（你的项目） | 你决定"拨哪些开关" |
| 生成层 | `autoconf.h`（编译时生成） | 转成 C 宏供代码使用 |

`prj.conf` 里的配置会覆盖板卡默认配置。

---

## 三、prj.conf 写法

```ini
# 启用功能
CONFIG_GPIO=y
CONFIG_LOG=y
CONFIG_SHELL=y

# 禁用功能
CONFIG_LOG=n

# 设置数值
CONFIG_LOG_BUFFER_SIZE=1024
CONFIG_SYS_CLOCK_TICKS_PER_SEC=1000
```

**逆向推导法**（不需要死记）：

| 代码里用到 | prj.conf 需要加 |
|-----------|----------------|
| `gpio_xxx()` | `CONFIG_GPIO=y` |
| `printk()` | `CONFIG_PRINTK=y` |
| `uart_xxx()` | `CONFIG_UART=y` |
| `i2c_xxx()` | `CONFIG_I2C=y` |
| `LOG_INF()` | `CONFIG_LOG=y` |

---

## 四、menuconfig：图形化查找 CONFIG

不需要背配置项名称，用搜索：

```bash
west build -t menuconfig
```

打开后按 `/` 输入关键词搜索（如 `GPIO`），能看到完整名称、当前值、依赖关系。

修改后保存会生成临时 `.config`，下次编译生效。

---

## 五、配置片段（多环境管理）

项目可以有多个 conf 文件，按场景叠加：

```bash
# 调试版：基础配置 + 调试配置
west build -b <board> -- -DCONF_FILE="prj.conf;debug.conf"
```

`debug.conf` 里的配置会覆盖 `prj.conf` 里相同的项，相当于打"补丁"。

---

## 六、验证配置是否真的生效

编译后查看最终配置结果：

```bash
# 搜索某个 CONFIG 的最终值
grep CONFIG_LOG build/zephyr/.config
```

如果你在 `prj.conf` 写了 `=y` 但最终显示 `=n`，说明它的依赖项没有满足，需要一并开启。
