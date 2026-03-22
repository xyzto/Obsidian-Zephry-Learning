# 线程基础与优先级抢占

> 日期：2026-03-20
> 目标板：qemu_cortex_m3
> 关联 Concept：[[Thread]]

## 目标

验证静态线程定义、优先级抢占机制以及 `k_msleep` 对调度的影响。

---

## 关键机制

**抢占时机**：高优先级线程从 `k_msleep` 醒来变为就绪态的瞬间，调度器立即调用 `z_swap()` 剥夺低优先级线程的 CPU，不需要等当前线程主动让出。

**饥饿现象**：高优先级线程不阻塞时，低优先级线程永远无法运行；`k_msleep` 是线程主动让出 CPU 的关键触发器。

**同优先级处理**：`CONFIG_TIMESLICING` 时间片机制负责同优先级线程之间的轮转，是抢占式调度在优先级相同时的降级处理。

**静态线程生命周期**：`K_THREAD_DEFINE` 在编译期分配栈和控制块，`main()` 返回后内核不退出，已定义线程持续运行。

---

## 源码位置

→ 源码路径：`kernel/sched.c`、`kernel/thread.c`
→ 关键函数：`z_impl_k_sleep()`、`z_swap()`、`z_priq_best_get()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>

void thread_a(void *a, void *b, void *c)
{
    while (1) {
        printk("Thread A (high priority)\n");
        k_msleep(500);
    }
}

void thread_b(void *a, void *b, void *c)
{
    while (1) {
        printk("Thread B (low priority)\n");
        k_msleep(1000);
    }
}

K_THREAD_DEFINE(tid_a, 512, thread_a, NULL, NULL, NULL, 5, 0, 0);
K_THREAD_DEFINE(tid_b, 512, thread_b, NULL, NULL, NULL, 10, 0, 0);

int main(void)
{
    printk("Main done, threads running\n");
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
west build -b qemu_cortex_m3 <app路径>
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

Thread A（高优先级）和 Thread B（低优先级）按各自频率交替打印。将 A 的 `k_msleep` 去掉后，B 完全无法获得执行权，出现"饥饿"现象，验证了高优先级线程不阻塞则低优先级永远得不到 CPU。`main()` 返回后内核不会退出，已定义的线程继续运行。

---

## 坑

**现象**：修改了代码中的优先级数值，但编译出的镜像运行结果没变
**原因**：增量编译有时未能正确识别宏定义修改，或者 CMake 缓存了旧配置
**解决**：使用 `west build -p always` 强制重新配置并编译

---

## 结论

RTOS 调度的核心是基于优先级的抢占式调度，`k_msleep` 是线程主动让出 CPU 并进入等待状态的关键触发器，是实现多线程协作的基础。换成 STM32F103ZE 实板，内核调度行为与 QEMU 完全一致，无迁移成本。

---

## 疑问与解答

**Q：为什么 Thread A 和 B 的优先级相同且都不休眠时，依然能交替运行？**

A：因为 Zephyr 默认开启了 `CONFIG_TIMESLICING`（时间片轮转）。在同优先级下，内核会强行切换线程，防止某个线程无限占用 CPU。

---

**Q：如果把 Thread A 优先级设为 5，Thread B 设为 10，且 A 不休眠，B 还能跑吗？**

A：不能。抢占优先级高于时间片轮转。高优先级线程如果不阻塞或休眠，低优先级线程永远无法运行。

---

## 反哺

→ [[01-Concepts/Thread]]
