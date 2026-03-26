# 实验 11 调度器综合（多优先级 + 时间片 + 协作式混合）

> 日期：2026-03-22
> 
> 目标板：qemu_cortex_m3
> 
> 关联 Concept：[[01-Concepts/Scheduling]] | [[01-Concepts/ThreadPriority]] | [[01-Concepts/TimeSlicing]]

## 目标

验证 Zephyr 调度器综合行为：高优先级抢占、同优先级时间片轮转（Round Robin）、以及通过 `k_yield()` 实现的协作式让出。

## 关键机制

**优先级抢占**：内核始终选择就绪队列中数值最小（优先级最高）的线程运行。当高优先级线程从睡眠中唤醒，会立即剥夺当前低优先级线程的 CPU 权。

**同优先级时间片轮转**：当 `CONFIG_TIMESLICING=y` 时，处于同一优先级的抢占式线程按照指定的 Tick 数轮流执行，防止单线程霸占 CPU。

**协作式让出**：通过 `k_yield()` 主动将当前线程移至同优先级就绪链表的末尾，给同级或更高优先级线程运行机会。

**就绪队列结构**：内核维护一个优先级位图指向的多个双向循环链表。调度器只需检查非空最高优先级链表的头部节点。

## 源码位置

→ 源码路径：kernel/sched.c 、 kernel/include/kernel_arch_func.h

→ 关键函数：z_swap、z_move_thread_to_end_of_prio_q、z_time_slice、k_yield

## 源码

### main.c
```c
#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024

// 1. 高优先级线程：周期性打断全场
void high_thread(void *p1, void *p2, void *p3) {
    while (1) {
        printk("[High Pri 3] --- Interrupting ---\n");
        k_msleep(800); 
    }
}

// 2. 中优先级线程：模拟计算负载并主动 yield
void mid_thread(void *p1, void *p2, void *p3) {
    int count = 0;
    while (1) {
        count++;
        printk("[Mid Pri 5] Running, count %d\n", count);
        k_busy_wait(200000); // 消耗 200ms CPU 不进入睡眠
        if (count % 3 == 0) {
            printk("[Mid Pri 5] Yielding...\n");
            k_yield(); 
        }
    }
}

// 3. 低优先级线程组：验证时间片轮转
void low_thread(void *name, void *p2, void *p3) {
    while (1) {
        printk("[Low Pri 7] Thread %s running\n", (char *)name);
        k_msleep(100);
    }
}

K_THREAD_DEFINE(th, STACK_SIZE, high_thread, NULL, NULL, NULL, 3, 0, 0);
K_THREAD_DEFINE(tm, STACK_SIZE, mid_thread, NULL, NULL, NULL, 5, 0, 0);
K_THREAD_DEFINE(tl1, STACK_SIZE, low_thread, "A", NULL, NULL, 7, 0, 0);
K_THREAD_DEFINE(tl2, STACK_SIZE, low_thread, "B", NULL, NULL, 7, 0, 0);

int main(void) {
    printk("Experiment 11 - Scheduler Mixing Start\n");
    return 0;
}
```

### prj.conf

```ini
CONFIG_STDOUT_CONSOLE=y
CONFIG_TIMESLICING=y
CONFIG_TIMESLICE_SIZE=10
CONFIG_TIMESLICE_PRIORITY=5
CONFIG_PRINTK=y
```

## 运行命令



```Bash
west build -b qemu_cortex_m3
west build -t run
```

## 现象

1. **抢占**：`High Pri 3` 每次唤醒时，无论谁在跑都会立即被中断。
    
2. **协作**：`Mid Pri 5` 通过 `k_busy_wait` 独占 CPU，每 3 次循环手动 `yield` 后，才轮到低优先级运行。
    
3. **轮转**：`Low Pri 7` 的 A 和 B 在没有高优先级干扰时，表现出标准的交替打印行为。
    

## 坑

**现象**：同优先级线程不轮转，一直跑 A。

**原因**：未开启 `CONFIG_TIMESLICING` 或 `CONFIG_TIMESLICE_PRIORITY` 阈值设置高于线程优先级（例如设为 10，则优先级 7 不受控）。

**解决**：确保 `CONFIG_TIMESLICE_PRIORITY <= 线程优先级数值`。

---

**现象**：日志出现乱序或部分丢失。

**原因**：高频 `printk` 导致串口缓冲区溢出。

**解决**：在测试代码中适当增加 `k_busy_wait` 或 `k_msleep` 降低输出频率。

## 结论

Zephyr 调度器通过优先级链表实现了确定性的抢占逻辑，并通过时间片补偿了同级线程的公平性。`k_yield` 提供了灵活的任务编排手段。内核机制层，QEMU 与 STM32F103ZE 实板逻辑高度一致，但在实板上需注意硬件中断对线程的时间片占用。

## 疑问与解答

**Q：时间片轮转是怎么实现的？**

A：在每个系统 Tick 中，`z_time_slice()` 检查当前线程已运行的时间。若达到 `CONFIG_TIMESLICE_SIZE`，则将其移至同优先级链表尾部并触发调度。

---

**Q：yield 和 sleep 的本质区别？**

A：`yield` 仅让出 CPU 给**同/高**优先级线程，线程仍处于 **READY** 状态；`sleep` 会将线程移出就绪队列进入 **PENDING** 状态，直到时间到期。

## 反哺

→ [[01-Concepts/Scheduling]]

→ [[01-Concepts/ThreadPriority]]

→ [[01-Concepts/TimeSlicing]]

---
