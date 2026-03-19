# Zephyr 开发流程

> 关联概念：[[Zephyr]] | [[Overlay]] | [[Kconfig]] | [[West]] | [[DeviceTree]]

## 一、标准五步开发流程

### 第 1 步：创建项目结构

一个最简 Zephyr 项目必须包含：
```
app/
├── src/main.c       # 业务逻辑
├── prj.conf         # 功能开关（Kconfig）
├── app.overlay      # 硬件配置（Devicetree）
└── CMakeLists.txt   # 构建描述
```

**CMakeLists.txt 最小写法（死记）：**
```cmake
cmake_minimum_required(VERSION 3.20)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(my_app)
target_sources(app PRIVATE src/main.c)
```

### 第 2 步：配置功能（prj.conf）

根据代码中使用的 API 来推导需要开启哪些 CONFIG：

| 代码中用到 | prj.conf 需要加 |
|-----------|----------------|
| `gpio_xxx()` | `CONFIG_GPIO=y` |
| `printk()` | `CONFIG_PRINTK=y` |
| `uart_xxx()` | `CONFIG_UART=y` |
| `i2c_xxx()` | `CONFIG_I2C=y` |
| `k_thread_create()` | 默认开启 |

**查找所有可用 CONFIG 的方法：**
```bash
west build -t menuconfig   # 图形化界面，按 / 搜索关键词
```

### 第 3 步：描述硬件（app.overlay）

**三步查填法：**

1. **查控制器真名**：先运行 `west build`，打开 `build/zephyr/zephyr.dts`，搜索 `gpio` 确认控制器叫 `gpio0` 还是 `gpioa`
2. **套模板填写**：
```dts
#include <zephyr/dt-bindings/gpio/gpio.h>

/ {
    aliases {
        led-status = &my_led;
    };
    leds {
        compatible = "gpio-leds";
        my_led: led_0 {
            gpios = <&gpio0 7 GPIO_ACTIVE_HIGH>;
        };
    };
};
```
3. **验证合并结果**：编译后再次打开 `build/zephyr/zephyr.dts`，确认别名正确合并

### 第 4 步：编写代码（main.c）

```c
// 拿设备句柄
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(DT_ALIAS(led_status), gpios);

int main(void)
{
    // 检查设备就绪
    if (!device_is_ready(led.port)) { return -1; }
    
    gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
    
    while (1) {
        gpio_pin_toggle_dt(&led);
        k_sleep(K_MSEC(500));
    }
}
```

### 第 5 步：编译、烧录、调试

```bash
west build -b <board>          # 编译（第一次）
west build -p always -b <board>  # 强制清理重编（改了 overlay 必用）
west flash                     # 烧录
```

---

## 二、Board Bring-up（新板子上手流程）

### 阶段 1：物理审计
- 查原理图，确认 LED/按键接在哪个引脚
- 确认有效电平（Active High / Active Low）
- 确认晶振频率（影响波特率精度）

### 阶段 2：环境对齐
```bash
west boards   # 查看 Zephyr 是否官方支持你的板子
```
如果不支持，找芯片型号相同的最接近板子作为模板。

### 阶段 3：真相探测
先不写代码，运行 `west build -b <board>`，打开 `build/zephyr/zephyr.dts`：
- 搜索 `gpio`：确认控制器真名
- 搜索 `uart`：确认调试串口物理地址

### 阶段 4：硬件抽象
编写 `app.overlay`，将物理引脚映射为业务逻辑（如 `led-status`）。

### 阶段 5：冒烟测试
```c
// 最小验证代码
int main(void) {
    printk("Hello World\n");
    // 先不写复杂逻辑，只验证串口和引脚是否通
    gpio_pin_toggle_dt(&led);
}
```

---

## 三、四层推导框架

| 层级 | 文件 | 回答的问题 |
|------|------|-----------|
| 生存环境层 | `CMakeLists.txt` | 这是一个 Zephyr 项目，源码在哪 |
| 功能清单层 | `prj.conf` | 我要用哪些内核超能力 |
| 物理地图层 | `app.overlay` | 外设接在哪个引脚上，叫什么名字 |
| 逻辑大脑层 | `src/main.c` | 谁负责触发，谁负责干活，怎么通信 |

**从下往上构建，从上往下排查。**

---

## 四、多线程开发模式

```c
K_SEM_DEFINE(my_sem, 0, 1);   // 定义信号量

// 后台线程：等待信号
void worker_thread(void *a, void *b, void *c) {
    while (1) {
        k_sem_take(&my_sem, K_FOREVER);
        // 执行任务
    }
}
K_THREAD_DEFINE(worker, 512, worker_thread, NULL, NULL, NULL, 5, 0, 0);

// 主线程：发出信号
int main(void) {
    while (1) {
        k_sem_give(&my_sem);
        k_sleep(K_MSEC(1000));   // 每个 while(1) 必须有 k_sleep，否则线程"饿死"其他线程
    }
}
```

---

## 五、关键心法

- **遇到新功能**：去 `zephyr/samples/` 文件夹"抄" `prj.conf` 和 `app.overlay`
- **遇到奇怪报错**：`west build -t menuconfig` 检查配置是否真的开启
- **不知道引脚怎么填**：看 `build/zephyr/zephyr.dts` 确认控制器名字
- **永远不要**修改 `zephyr/` 源码目录下的 DTS 文件
