# 实验 08：事件标志 (k_event)

> 日期：2026-03-22
> 目标板：qemu_cortex_m3
> 关联 Concept：[[01-Concepts/EventFlags]] | [[01-Concepts/ThreadSynchronization]]

## 目标

验证 `k_event` 的多位组合等待机制（AND 逻辑），实现多传感器数据同步模拟。

---

## 关键机制

`k_event` 维护一个 32 位事件位图和等待队列。`k_event_post` 对位图执行 OR 操作，并遍历等待队列唤醒满足条件的线程。`k_event_wait` 支持 AND（全部满足）和 OR（任一满足）两种等待逻辑，`reset` 参数控制唤醒后是否自动清除已消费的位。相比信号量，事件标志允许多个线程同时等待同一事件位，实现广播通知，是多条件触发场景的首选机制。

---

## 源码位置

→ 源码路径：`kernel/events.c`
→ 关键函数：`z_impl_k_event_post()`、`z_impl_k_event_wait()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>

#define EVENT_BIT_A BIT(0)
#define EVENT_BIT_B BIT(1)

struct k_event my_event;

void producer_thread(void *p1, void *p2, void *p3) {
    while (1) {
        k_msleep(1000);
        printk("[Thread A]: Sensor A data ready, posting event...\n");
        k_event_post(&my_event, EVENT_BIT_A);

        k_msleep(500);
        printk("[Thread B]: Sensor B data ready, posting event...\n");
        k_event_post(&my_event, EVENT_BIT_B);
    }
}

K_THREAD_DEFINE(p_id, 1024, producer_thread, NULL, NULL, NULL, 7, 0, 0);

int main(void) {
    k_event_init(&my_event);
    while (1) {
        /* 等待 A 和 B 同时完成 (WAIT_ALL)，且读取后自动清除 (true) */
        uint32_t ret = k_event_wait(&my_event, (EVENT_BIT_A | EVENT_BIT_B), true, K_FOREVER);
        if (ret != 0) {
            printk(">>> [Main]: Sync Success! Processed data from A and B at %lld ms\n", k_uptime_get());
        }
    }
    return 0;
}
```

### prj.conf

```ini
CONFIG_STDOUT_CONSOLE=y
CONFIG_EVENTS=y
```

### app.overlay（可选）

```dts
/* QEMU 实验无需 overlay */
```

---

## 运行命令

```bash
west build -b qemu_cortex_m3 my_projects/EventFlags
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

Consumer（Main）线程每隔约 1500ms 触发一次同步输出。即使 Thread A 的事件位先到达，Main 线程也会严格等待 Bit B 到达后才被唤醒，验证了 AND 逻辑的多条件同步行为。

---

## 坑

**现象**：编译报错 `undefined reference to z_impl_k_event_post`
**原因**：`k_event` 组件默认未开启，内核未编译 `events.c`
**解决**：在 `prj.conf` 中添加 `CONFIG_EVENTS=y`

---

**现象**：多个线程等待同一事件位时只有一个被唤醒
**原因**：`k_event_wait` 的 `reset` 参数设为 `true`，第一个线程醒来即清除了标志位
**解决**：若需广播通知，应设为 `false` 并手动控制清除时机

---

## 结论

`k_event` 支持 AND/OR 逻辑，适合多条件触发场景，是比信号量更灵活的多线程同步机制。`reset` 参数决定事件是否"一次性"消费，广播场景需设为 `false`。换成 STM32F103ZE 实板，`k_event_post` 可直接在 ISR 中调用，内核自旋锁保证操作原子性，无迁移成本。

---

## 疑问与解答

**Q：`k_event_post` 是否可以在 STM32 的中断（ISR）中使用？**

A：可以。内核 API 内部实现了自旋锁（Spinlock），在单核 STM32 上会自动处理中断竞争，保证操作的原子性。

---

**Q：多个线程可以同时等待同一个事件位吗？**

A：可以。这是事件标志与信号量的重大区别。多个线程可以同时阻塞在同一个事件上，当位满足时，所有符合条件的线程都会被唤醒（前提是 `reset` 为 `false`）。

---

## 反哺

→ [[01-Concepts/EventFlags]]
→ [[01-Concepts/ThreadSynchronization]]
