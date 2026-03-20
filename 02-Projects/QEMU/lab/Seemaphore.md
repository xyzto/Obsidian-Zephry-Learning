# 实验 03：信号量同步 (Semaphore Sync)

> 日期：2026-03-20
> 目标板：qemu_cortex_m3
> 关联 Concept：[[Semaphore]] | [[Thread_States]]

## 目标

验证 Zephyr 信号量（Semaphore）在线程间的同步机制，实现生产者-消费者模型，观察线程阻塞与唤醒的行为。

## 源码

### main.c

```c
#include <zephyr/kernel.h>

/* 定义信号量：初始值 0，最大值 1 */
K_SEM_DEFINE(sync_sem, 0, 1);

#define STACK_SIZE 1024

void producer_thread(void *p1, void *p2, void *p3) {
    while (1) {
        k_msleep(2000);
        printk("[Producer]: Data ready, giving semaphore...\n");
        k_sem_give(&sync_sem);
    }
}

void consumer_thread(void *p1, void *p2, void *p3) {
    while (1) {
        k_sem_take(&sync_sem, K_FOREVER);
        printk("[Consumer]: Got semaphore! Processing data now.\n");
    }
}

K_THREAD_DEFINE(prod_id, STACK_SIZE, producer_thread, NULL, NULL, NULL, 7, 0, 0);
K_THREAD_DEFINE(cons_id, STACK_SIZE, consumer_thread, NULL, NULL, NULL, 7, 0, 0);

int main(void) { return 0; }
```

### prj.conf

```ini
CONFIG_PRINTK=y
```

## 运行命令

```bash
west build -b qemu_cortex_m3 samples/my_app -p always
west build -t run
```

## 现象

1. Consumer 启动后在 `k_sem_take` 处立即阻塞。
2. 每隔 2 秒，Producer 打印 `Data ready` 并释放信号量。
3. Consumer 几乎瞬间被唤醒，打印 `Got semaphore!`，随后再次进入阻塞等待。

## 本质机制

- **内核对象**：`struct k_sem` 维护一个 `count` 和一个 `_wait_q`（等待队列）。
- **执行路径**：
  - `k_sem_take` → 若 `count==0` → 调用 `z_pend_curr()` → 线程状态设为 `_THREAD_PENDING` → 触发 `z_swap` 切换到其他就绪线程。
  - `k_sem_give` → 调用 `z_unpend_first_thread()` → 从 `_wait_q` 移出首个线程 → 设为就绪态 → 等待调度器切回。
- **源码位置**：`kernel/sem.c`

## 坑

**现象**：Consumer 线程不阻塞，疯狂打印。
**原因**：`K_SEM_DEFINE` 时将初始值设为了 1，导致第一次 `take` 直接成功。
**解决**：确保同步用途的信号量初始值为 0。

---

**现象**：在中断（ISR）中使用 `k_sem_take` 导致系统重启。
**原因**：中断上下文不允许执行可能导致阻塞的操作。
**解决**：中断里只能 `give`，不能 `take`（除非 timeout 为 `K_NO_WAIT`）。

## 结论

信号量不仅是计数器，更是线程调度器的开关。它通过挂起和唤醒机制，实现了比裸机轮询（Polling）更高效的 CPU 利用率和功耗控制。

## 硬件迁移思考

→ 换成 STM32F103ZE 需要改：
- DeviceTree：无需修改（内核机制不依赖设备树）。
- 驱动：若由硬件触发同步，需在 `app.overlay` 开启对应外设（如 UART/GPIO）。
- Kconfig：无需额外配置，除非涉及系统级优化。

→ 内核机制层差异：QEMU 与实板完全一致。但在实板上，建议由硬件中断（ISR）调用 `k_sem_give` 来处理实时异步事件。

## 疑问与解答

**Q：如果有多个同优先级线程在等同一个信号量，谁先醒？**

A：Zephyr 默认采用先来先服务（FIFO）原则，即先调用 `take` 的线程先被唤醒；但如果开启了优先级排序，则最高优先级线程先醒。

---

**Q：信号量能当互斥锁（Mutex）用吗？**

A：技术上可以（二值信号量），但信号量没有"优先级继承"机制，容易引发优先级翻转风险。

## 反哺

→ [[Semaphore]]
→ [[Thread_States]]
