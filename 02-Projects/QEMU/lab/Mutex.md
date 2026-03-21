# 实验 04：互斥锁与优先级继承

> 日期：2026-03-21
> 目标板：qemu_cortex_m3
> 关联 Concept：[[Thread]]

## 目标

验证 Mutex 对共享资源的互斥访问机制，观察并理解内核如何通过优先级继承解决高优先级线程被低优先级线程无限期阻塞的问题。

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>

K_MUTEX_DEFINE(my_mutex);

void shared_resource_task(const char *name, uint32_t sleep_ms)
{
    k_mutex_lock(&my_mutex, K_FOREVER);
    printk("Thread %s: Grabbed mutex, starting work...\n", name);
    k_msleep(sleep_ms);
    printk("Thread %s: Work done, releasing mutex.\n", name);
    k_mutex_unlock(&my_mutex);
}

void high_thread_fn(void *p1, void *p2, void *p3)
{
    k_msleep(500); /* 确保低优先级先拿锁 */
    printk("High Thread: Trying to get mutex...\n");
    shared_resource_task("HIGH", 500);
}

void low_thread_fn(void *p1, void *p2, void *p3)
{
    shared_resource_task("LOW", 2000);
}

/* 数值越小优先级越高：High(5), Low(10) */
K_THREAD_DEFINE(high_id, 1024, high_thread_fn, NULL, NULL, NULL, 5,  0, 0);
K_THREAD_DEFINE(low_id,  1024, low_thread_fn,  NULL, NULL, NULL, 10, 0, 0);

int main(void) { return 0; }
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
west build -b qemu_cortex_m3 <app路径> -p always
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

LOW 线程启动并持有 Mutex。HIGH 线程在 500ms 后尝试 lock 但被阻塞。此时发生优先级继承，LOW 临时提升为优先级 5，防止被中优先级线程抢占。LOW 释放锁后优先级恢复为 10，HIGH 线程立即抢占 CPU 并成功获取 Mutex。

---

## 坑

**现象**：在中断回调函数（ISR）中使用 `k_mutex_lock` 导致系统 Panic
**原因**：Mutex 带阻塞属性且依赖优先级继承，ISR 没有线程栈，无法被挂起，也不具备线程优先级
**解决**：中断中应使用信号量（Semaphore）进行非阻塞同步

---

**现象**：程序运行到一半卡死，控制台不再输出
**原因**：逻辑死锁（Deadlock），两个线程互锁对方资源
**解决**：统一加锁顺序，或使用带超时的 `k_mutex_lock` 并对返回值进行判断

---

## 结论

Mutex 的本质是"带所有权的信号量"加上"优先级继承算法"。它能动态调整持有锁线程的优先级，确保高优先级任务的实时响应边界不被中优先级任务破坏。

---

## 疑问与解答

**Q：为什么信号量没有优先级继承，而 Mutex 有？**

A：信号量没有 Owner（谁都可以 give），内核不知道该给谁提速；Mutex 记录了持有者线程 ID，内核可以精准定位并提升其优先级。

---

**Q：优先级继承底层调用了哪个函数？**

A：底层最终调用了 `z_thread_priority_set()`。在 `k_mutex_lock` 阻塞时提升 Owner 优先级，在 `k_mutex_unlock` 时恢复。

---

**Q：如果不使用 Mutex，裸机怎么保护共享资源？**

A：通常使用 `__disable_irq()` 关全局中断。副作用是关中断期间无法响应任何硬件事件，增加系统实时抖动（Jitter）。

---

## 反哺

→ [[Thread]]
