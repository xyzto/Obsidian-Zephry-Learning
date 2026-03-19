# Overlay

> 关联概念：[[DeviceTree]] | [[Kconfig]] | [[Zephyr开发流程]]

## 一、Overlay 是什么

Overlay 是 Zephyr 的**硬件配置补丁机制**。每块开发板都有一个官方的基础 Devicetree（`board.dts`），当你的项目需要修改硬件配置时，不能直接改官方文件，而是通过 Overlay 来"打补丁"。

```
board.dts（官方底稿）
    +
app.overlay（你的补丁）
    =
最终合并的 Devicetree
```

**为什么不直接改 board.dts？**
- Overlay 属于你的项目代码，可以放进 Git；官方 DTS 是环境库，不应改动。
- 换板子时只改 Overlay，C 代码一行不动。

---

## 二、Overlay 能做什么

1. **启用或关闭设备**：`status = "okay";` / `status = "disabled";`
2. **修改设备属性**：修改波特率、频率等参数
3. **添加新外设**：挂载传感器、LED、按键等

---

## 三、语法核心（5 条死规则）

### 规则 1：根节点是所有内容的容器
```dts
/ {
    /* 所有内容都写在这里 */
};
```

### 规则 2：层级 = 文件夹嵌套
```dts
/ {
    leds {          /* 父分类 */
        led_0 { };  /* 具体零件 */
    };
};
```

### 规则 3：属性格式永远是 `名字 = 值;`
- `compatible = "gpio-leds";` — **最关键**，告诉系统"我是什么"，驱动靠它匹配
- `gpios = <&gpio0 7 GPIO_ACTIVE_HIGH>;` — 连线图，`< >` 装硬件参数
- `status = "okay";` — 启用设备

### 规则 4：冒号与 & 的区别（最易混淆）
- `label: node_name { }` — **冒号前**是"绰号"，供外部引用
- `prop = &label;` — **& 是指路**，去找那个绰号的节点

### 规则 5：分号不能丢
每个 `}` 后面必须有 `;`，每行属性后面必须有 `;`。

---

## 四、万能模板

```dts
#include <zephyr/dt-bindings/gpio/gpio.h>

/ {
    aliases {
        led-status = &my_led;   /* C 代码通过别名查找 */
    };

    leds {
        compatible = "gpio-leds";       /* 驱动匹配的唯一凭证 */
        my_led: led_0 {
            gpios = <&gpio0 7 GPIO_ACTIVE_HIGH>;  /* 控制器 引脚 电平 */
        };
    };
};
```

**在 C 代码中使用：**
```c
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(DT_ALIAS(led_status), gpios);
```
> 注意：Overlay 里写 `led-status`（横杠），C 代码里写 `led_status`（下划线），Zephyr 自动转换。

---

## 五、专家开发流程（四步法）

### 第 1 步：查底稿，确认控制器真名
先编译一次（哪怕没有代码），打开 `build/zephyr/zephyr.dts`，搜索 `gpio`：
```
gpio0: gpio@40004000   ← 冒号前的 gpio0 就是你要用的名字
```

### 第 2 步：写 Overlay，描述接线
根据原理图填写引脚号，套用上面的万能模板。

### 第 3 步：引入宏头文件
如果要用 `GPIO_ACTIVE_HIGH` 等语义化宏，开头必须加：
```dts
#include <zephyr/dt-bindings/gpio/gpio.h>
```
否则只能写 `0`，可读性差。

### 第 4 步：编译验证
```bash
west build -p always -b <board>
```
加 `-p always` 强制清理缓存，避免 Overlay 修改后不生效。再次打开 `build/zephyr/zephyr.dts` 确认别名是否正确合并。

---

## 六、避坑清单

| 检查项 | 没做会怎样 |
|--------|-----------|
| `compatible` 拼写正确 | 驱动加载失败，`device_is_ready()` 返回 false |
| 引脚号未越界 | 报错"无法配置 GPIO 引脚" |
| 引入 `#include` 头文件 | 报错 `expected number or parenthesized expression` |
| 编译加 `-p always` | 改了文件但运行结果不变 |

---

## 七、compatible 的本质

`compatible` 是连接硬件描述和软件驱动的唯一胶水：

| compatible 值 | 加载的驱动能力 |
|--------------|--------------|
| `"gpio-leds"` | 开关灯 |
| `"pwm-leds"` | 调亮度（呼吸灯） |
| `"gpio-keys"` | 读按键 |
| `"bosch,bme280"` | 读温湿度 |

系统在编译时扫描所有驱动，找到声明能处理同一 `compatible` 字符串的驱动，自动绑定。
