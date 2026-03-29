# MessageQueue（消息队列）

> 关联概念：[[Thread]] | [[Semaphore]] | [[Mutex]]
> 来源问题：[[05-Questions/线程调度相关问题集]]

## 本质

`k_msgq` 是 Zephyr 内核提供的**线程安全有界环形缓冲区**，内核自动管理等待队列、阻塞/唤醒、上下文切换和临界区保护（spinlock）。

消息队列 = 有界缓冲 + 阻塞式同步。它是生产者–消费者模型的直接载体。

## 解决什么问题

消息队列一次性解决并发系统中五类核心问题：

**速度不一致**：生产者（传感器 1ms 采样）与消费者（处理线程 10ms 一次）速度天然不匹配，队列作为缓冲将两者解耦，让各自按自己节奏运行。

**数据竞争**：两个线程直接共享内存会导致偶发崩溃和数据损坏。队列内部用 `k_spinlock` 保证同一时刻只有一个线程操作，数据永远完整。

**忙等浪费 CPU**：裸机 `while(buffer_empty()){}` 会独占 CPU。队列空时消费者自动阻塞，队列满时生产者自动阻塞，CPU 交给其他线程。

**数据丢失/覆盖/乱序**：有界缓冲保证 FIFO 顺序，不覆盖，不乱序（除非显式选择 `K_NO_WAIT` 放弃等待）。

**模块强耦合**：无队列时生产者必须直接调用消费者。队列让两者完全独立——生产者只管放，消费者只管取，中间用队列隔离。

## 核心机制

**k_msgq_put（生产者写入）**

- 缓冲区未满 → 直接写入，若有等待的消费者立即唤醒一个
- 缓冲区已满 → `K_FOREVER` 阻塞挂入 writer wait queue；`K_NO_WAIT` 返回 `-ENOMSG`；超时值等待后返回 `-EAGAIN`

**k_msgq_get（消费者读取）**

- 缓冲区非空 → 直接读取，若有等待的生产者立即唤醒一个
- 缓冲区为空 → `K_FOREVER` 阻塞挂入 reader wait queue；`K_NO_WAIT` 返回 `-ENOMSG`

**调度器行为**：生产者或消费者阻塞时，Zephyr 把线程挂入等待队列并切走，条件满足时唤醒，超时到期也唤醒。整个过程无忙等，无数据竞争，自动调度。

## 与相关概念的区别

| | 信号量 | Mutex | 消息队列 |
|--|--------|-------|--------|
| 传数据 | 否 | 否 | 是 |
| 用途 | 发通知/计数 | 保护共享资源 | 线程间既通知又传数据 |
| ISR 可用 | give 可以 | 不可 | put 可以 |
| 缓冲 | 无 | 无 | 有界环形缓冲 |

**vs 裸机实现**：裸机需要自己写环形缓冲、禁中断/自旋锁、等待队列、超时机制、调度逻辑。Zephyr 只需 `k_msgq_put` / `k_msgq_get`，内核全部处理。

## 在 Zephyr 里怎么用

```c
// 定义队列：消息大小 sizeof(int)，容量 4，对齐 4 字节
K_MSGQ_DEFINE(my_msgq, sizeof(int), 4, 4);

void producer(void)
{
    int count = 0;
    while (1) {
        k_msgq_put(&my_msgq, &count, K_FOREVER);
        printk("Produced: %d\n", count);
        count++;
        k_sleep(K_MSEC(500));
    }
}

void consumer(void)
{
    int value;
    while (1) {
        k_msgq_get(&my_msgq, &value, K_FOREVER);
        printk("Consumed: %d\n", value);
    }
}

K_THREAD_DEFINE(prod_id, 1024, producer, NULL, NULL, NULL, 5, 0, 0);
K_THREAD_DEFINE(cons_id, 1024, consumer, NULL, NULL, NULL, 5, 0, 0);
```

**验证点**：输出应交替出现 Produced / Consumed。消费者速度慢 → 生产者阻塞；生产者速度慢 → 消费者阻塞。

**源码位置**：`kernel/msg_q.c` → `z_impl_k_msgq_put` / `z_impl_k_msgq_get` / `z_msgq_put_internal` / `z_msgq_get_internal`

**QEMU → STM32F103ZE**：k_msgq 完全在内核层，不依赖外设，行为 100% 一致。迁移只需保证 UART 打印正常、线程栈足够。

## 坑

**现象**：中断里调用 `k_msgq_put` 配合 `K_FOREVER` 导致系统 Panic。
**原因**：ISR 没有线程栈，无法被挂起，阻塞调用会破坏内核调度。
**解决**：ISR 中只用 `K_NO_WAIT`，满了就丢弃或用 `k_msgq_purge` 清队列。

## 产生的问题

→ [[05-Questions/线程调度相关问题集]]

## 验证记录

→ [[02-Projects/QEMU/lab/Exp04-MessageQueue]]
