# Zephyr 启动与设备初始化

> 关联概念：[[Zephyr]] | [[Zephyr编译系统]] | [[DeviceTree]] | [[Thread]]

## 一、启动全流程

```
CPU 上电（Reset Handler）
    ↓
准备 C 环境（_PrepC）
    初始化堆栈，DATA 段从 Flash 搬到 RAM，清空 BSS 段
    ↓
内核初始化（z_cstart）
    按阶段自动初始化所有设备（见下节）
    ↓
启动多线程调度器
    创建主线程（Main Thread）和空闲线程（Idle Thread）
    ↓
进入 main()
```

你写的 `main.c` 代码从最后一步才开始执行，此前内核已经完成了所有硬件初始化。

---

## 二、设备自动初始化机制

Zephyr 不需要你手动调用 `UART_Init()`，设备由内核在启动时统一初始化。这套机制依赖三个部分：

### 1. DEVICE_DT_DEFINE — 驱动注册

驱动源码里用这个宏把设备注册到系统：

```c
/* drivers/uart/uart_stm32.c */
DEVICE_DT_DEFINE(DT_NODELABEL(uart1),
                 uart_stm32_init,       /* init 函数 */
                 NULL,
                 &uart1_data,
                 &uart1_cfg,
                 PRE_KERNEL_1,          /* 初始化阶段 */
                 CONFIG_KERNEL_INIT_PRIORITY_DEVICE,
                 &uart_stm32_driver_api);
```

这个宏做两件事：生成 `struct device` 结构体，并通过 `__attribute__((section(".z_device")))` 把它放入特殊的 linker section。**此时硬件并未初始化，只是完成了注册。**

### 2. 系统启动遍历 — 统一调度

内核启动时遍历 `.z_device` section 里的所有设备，逐一调用它们的 init 函数：

```c
/* kernel/init.c */
for (dev = __device_start; dev < __device_end; dev++) {
    if (dev->init) {
        dev->init(dev);   /* 调用驱动的 init 函数 */
    }
}
```

### 3. 驱动 init 函数 — 真正操作硬件

```c
static int uart_stm32_init(const struct device *dev) {
    stm32_clock_enable(cfg->clock);           /* 启动时钟 */
    stm32_pin_configure(cfg->tx_pin, ALT_FUNC); /* 配置引脚 */
    LL_USART_SetBaudRate(cfg->uart, cfg->baud_rate); /* 配置寄存器 */
    LL_USART_Enable(cfg->uart);
    return 0;
}
```

**这里才是真正操作硬件寄存器的地方。**

---

## 三、完整调用链

```
DeviceTree (.dts / overlay)
    ↓ 编译期生成宏
DEVICE_DT_DEFINE（驱动源文件）
    ↓ 生成 struct device，放入 .z_device section
内核启动遍历（z_sys_init）
    ↓ 按阶段、按优先级调用 init
驱动 init 函数（uart_stm32_init）
    ↓ 操作寄存器
硬件启动完成
```

为什么你"看不到"这个调用：因为遍历发生在内核启动阶段，不在你的应用代码里，且宏展开和 linker section 把调用路径隐藏了。

---

## 四、初始化阶段（SYS_INIT）

内核将初始化分为有序的几个阶段：

| 阶段 | 时机 | 可用内核功能 |
|------|------|------------|
| `PRE_KERNEL_1` | 最早，调度器未启动 | 不能用信号量、互斥锁 |
| `PRE_KERNEL_2` | 调度器未启动 | 同上 |
| `POST_KERNEL` | 调度器已启动 | 可用 `k_yield()` 等 |
| `APPLICATION` | 应用初始化 | 全部内核功能可用 |

可以把自己的初始化代码挂载到指定阶段：

```c
/* 让传感器在系统启动时自动初始化，无需在 main 里调用 */
SYS_INIT(my_sensor_init, POST_KERNEL, 50);
```

---

## 五、printk 与 LOG 的区别

| | `printk` | `LOG_INF` |
|--|---------|-----------|
| 依赖 | 无需额外配置 | 需要 `CONFIG_LOG=y` |
| 可过滤 | 不可以 | 可以按级别过滤 |
| 适用场景 | 内核初始化阶段、紧急调试 | 正式项目的业务日志 |
| 格式 | 类 printf | 带时间戳和模块名 |

内核初始化阶段日志系统还未就绪，只有 `printk` 能用。

---

## 六、如何定位某个驱动的初始化路径

1. 找设备标签：`DT_NODELABEL(uart1)`
2. 搜索驱动源码：`drivers/uart/uart_stm32.c`
3. 在源文件里搜索 `DEVICE_DT_DEFINE` 找到 init 函数名
4. 直接阅读该 init 函数，即可看到完整的寄存器配置过程
