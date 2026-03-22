# 实验 06：定时器 (k_timer)

> 日期：2026-03-21
> 目标板：qemu_cortex_m3
> 关联 Concept：[[01-Concepts/Kernel_Timer]] | [[01-Concepts/Interrupt_Context]]

## 目标

验证 Zephyr 内核定时器 `k_timer` 的周期性触发机制，理解其作为软件定时器的运行限制及中断上下文（ISR）的特性。

---

## 关键机制

`k_timer` 是基于系统 Tick（SysTick）的软件定时器，利用一个硬件时钟模拟多个软件定时器。到期回调函数运行在系统时钟中断上下文（ISR），不是线程，没有独立栈，禁止任何阻塞操作。精度受 `CONFIG_SYS_CLOCK_TICKS_PER_SEC` 限制，默认 100Hz 对应 10ms 步长。对于耗时操作，应在回调中通过信号量或消息队列通知线程处理，保持回调"快进快出"。

---

## 源码位置

→ 源码路径：`kernel/timer.c`、`kernel/timeout.c`
→ 关键函数：`z_impl_k_timer_start()`、`z_timer_expiry_fn()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>

/* 定时器到期回调函数：注意！此函数运行在中断上下文 */
void my_expiry_fn(struct k_timer *timer_id)
{
    /* 仅限执行快速、非阻塞的操作 */
    printk("Timer expired at %lld ms\n", k_uptime_get());
}

/* 停止回调函数 */
void my_stop_fn(struct k_timer *timer_id)
{
    printk("Timer stopped.\n");
}

/* 静态定义定时器：对象名, 到期回调, 停止回调 */
K_TIMER_DEFINE(my_timer, my_expiry_fn, my_stop_fn);

int main(void)
{
    printk("Starting timers...\n");

    /* 启动周期性定时器：1秒后首响，之后每 500ms 触发一次 */
    k_timer_start(&my_timer, K_MSEC(1000), K_MSEC(500));

    /* 主线程休眠，观察触发情况 */
    k_msleep(3100);

    /* 手动停止定时器 */
    k_timer_stop(&my_timer);

    return 0;
}
```

### prj.conf

```ini
CONFIG_PRINTK=y
```

### app.overlay（可选）

```dts
/* QEMU 实验无需 overlay */
```

---

## 运行命令

```bash
west build -b qemu_cortex_m3 samples/my_app -p always
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

终端依次打印 `Starting timers...`，1000ms 后首次触发 `Timer expired at 1000 ms`，随后以 500ms 为固定周期连续触发，直到主线程在约 3100ms 时调用 `k_timer_stop`，输出 `Timer stopped.`。

---

## 坑

**现象**：在定时器回调函数 `my_expiry_fn` 中调用 `k_msleep` 或 `k_mutex_lock` 后系统直接 Panic
**原因**：定时器回调运行在中断上下文（ISR），禁止任何可能引起线程切换或阻塞的操作
**解决**：回调内仅执行标志位设置、信号量释放（`k_sem_give`）或消息队列入队（`k_msgq_put`），将耗时任务推后到线程处理

---

**现象**：设置 1ms 的定时器，但实际触发间隔不准
**原因**：`k_timer` 是基于系统 Tick 的软件定时器，`CONFIG_SYS_CLOCK_TICKS_PER_SEC` 为 100 时步长为 10ms，无法实现 1ms 精确调度
**解决**：提高系统 Tick 频率，或使用硬件 `Counter` 驱动直接操作 STM32 的 TIM 硬件定时器

---

## 结论

`k_timer` 是内核的异步闹钟机制，优势在于用一个硬件时钟模拟多个软件定时器，代价是精度受 Tick 限制且回调必须遵循快进快出原则。换成 STM32F103ZE 实板，`k_timer` API 层无差异，但底层 SysTick 频率由时钟树配置决定，需确认 `CONFIG_SYS_CLOCK_TICKS_PER_SEC` 与硬件时钟匹配。

---

## 疑问与解答

**Q：定时器回调和线程有什么本质区别？**

A：线程有自己的栈空间，可以被挂起和调度；回调运行在系统共享的中断栈，没有独立身份，不能阻塞。

---

**Q：如果定时时间到了，但此时系统正在处理一个更高优先级的中断，会发生什么？**

A：定时器回调会被推迟执行，产生"中断延迟"或"抖动"。对于强实时场景，必须压缩所有中断的处理时间。

---

**Q：如何用定时器触发一个需要执行 50ms 的写 Flash 操作？**

A：使用"定时器 + 信号量 + 线程"组合。定时器回调负责 `k_sem_give`，专门的 Flash 线程 `k_sem_take` 到信号量后执行写操作，这样不会阻塞系统时钟。

---

## 反哺

→ [[01-Concepts/Kernel_Timer]]
→ [[01-Concepts/Interrupt_Context]]
