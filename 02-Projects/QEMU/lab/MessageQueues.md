# 实验 05：消息队列 (k_msgq)

> 日期：2026-03-21
> 目标板：qemu_cortex_m3
> 关联 Concept：[[01-Concepts/Thread]]

## 目标

验证线程间异步通信机制。通过生产者-消费者模型，观察消息队列在缓冲区满、空状态下的线程挂起与唤醒行为。

---

## 关键机制

**数据结构**：`k_msgq` 内部维护环形缓冲区、发送等待队列和接收等待队列。

**阻塞路径（队列满）**：`k_msgq_put` 在队列满时调用 `z_pend_curr()` 挂起生产者，直到消费者取走数据腾出空间后被唤醒；空队列时消费者同理。

**数据拷贝**：每次传递经过两次内存拷贝（生产者栈 → 内核缓冲区 → 消费者栈），保证原子交换，但传递大块结构体开销不可忽视。

**工程实践**：传递大块数据时应改为传递指针，队列中只存地址，规避拷贝代价。

---

## 源码位置

→ 源码路径：`kernel/msgq.c`
→ 关键函数：`z_impl_k_msgq_put()`、`z_impl_k_msgq_get()`、`z_pend_curr()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>

struct data_item_t {
    uint32_t val;
    uint32_t timestamp;
};

/* 队列容量 3 条，每条 sizeof(data_item_t)，4 字节对齐 */
K_MSGQ_DEFINE(my_msgq, sizeof(struct data_item_t), 3, 4);

void producer_thread(void *p1, void *p2, void *p3)
{
    struct data_item_t data;
    uint32_t counter = 100;

    while (1) {
        data.val = counter++;
        data.timestamp = k_uptime_get_32();
        printk("[Producer]: Putting data %d into queue...\n", data.val);
        if (k_msgq_put(&my_msgq, &data, K_MSEC(1000)) != 0) {
            printk("[Producer]: Queue full, data dropped!\n");
        }
        k_msleep(500);
    }
}

void consumer_thread(void *p1, void *p2, void *p3)
{
    struct data_item_t received_data;

    while (1) {
        k_msgq_get(&my_msgq, &received_data, K_FOREVER);
        printk("[Consumer]: Got data: %d (at %d ms)\n",
               received_data.val, received_data.timestamp);
        k_msleep(2000);
    }
}

K_THREAD_DEFINE(prod_id, 1024, producer_thread, NULL, NULL, NULL, 7, 0, 0);
K_THREAD_DEFINE(cons_id, 1024, consumer_thread, NULL, NULL, NULL, 7, 0, 0);

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

Producer 快速连续生产并填满 3 个槽位。由于 Consumer 消费速度慢（2秒/条），队列迅速达到满状态，Producer 在尝试存放第 4 条数据时触发 1000ms 等待逻辑，超时后输出 `Queue full, data dropped!`。当 Consumer 处理完一条数据腾出空间后，Producer 被内核唤醒并成功放入新数据。

---

## 坑

**现象**：接收端读取到的结构体成员数值发生错位或出现随机乱码
**原因**：发送端传入的变量大小与 `K_MSGQ_DEFINE` 中的 `sizeof` 不匹配，内核按错误字节数拷贝内存
**解决**：统一使用同一结构体定义，`K_MSGQ_DEFINE` 和 API 调用处保持 `sizeof` 对象一致

---

**现象**：系统在中断逻辑中调用 `k_msgq_put` 时突然 Panic
**原因**：ISR 中设置了非零 Timeout 参数，中断上下文无法进入阻塞状态
**解决**：ISR 中调用消息队列 API 必须使用 `K_NO_WAIT`

---

## 结论

消息队列是实现线程间解耦和削峰填谷的核心组件，通过内核管理的环形缓冲区保证数据交换的原子性。换成 STM32F103ZE 实板，消息队列机制与 QEMU 完全一致，无迁移成本。

---

## 疑问与解答

**Q：数据在整个传递过程中经过了几次内存拷贝？**

A：两次。第一次从生产者局部变量拷贝到内核消息队列缓冲区，第二次从内核缓冲区拷贝到消费者的接收变量。

---

**Q：内核如何实现线程在队列满时的等待？**

A：底层调用 `z_pend_curr()` 将当前线程放入消息队列对象的发送等待链表，状态设为 `PENDING`。接收端取走数据腾出空间后，内核通过 `z_unpend_thread` 将其唤醒。

---

**Q：传递大块数据时为什么不直接塞进消息队列？**

A：消息队列的内存拷贝是同步阻塞 CPU 的，拷贝大块数据会消耗大量周期。最佳实践是配合内存池，队列中只传递 4 字节的地址指针。

---

## 反哺

→ [[01-Concepts/Thread]]
