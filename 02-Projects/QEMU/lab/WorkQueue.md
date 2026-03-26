# 实验 07 工作队列 k_work / k_work_delayable

> 日期：2026-03-22
> 
> 目标板：qemu_cortex_m3
> 
> 关联 Concept：[[01-Concepts/k_work]] | [[01-Concepts/WorkQueue]]

## 目标

验证 Zephyr 工作队列机制：将耗时任务从中断或高优先级上下文延迟提交到系统工作线程执行，确保系统实时性。

## 关键机制

**系统工作线程**：`system_work_q`，优先级通常为 0，是内核启动时自动创建的专用线程，循环处理提交的工作项。

**任务卸载**：在中断中通过 `k_work_submit` 将函数指针封装在 `k_work` 中，实现执行环境从当前上下文切换到后台工作线程。

**延迟调度**：`k_work_schedule` 先将任务放入内核超时队列（timeout_q），由系统 Tick 触发后再移入 `pending list`。

**非阻塞特性**：中断或任何上下文调用 `submit`/`schedule` 后立即返回，不阻塞调用者，由调度器决定 `handler` 执行时机。

## 源码位置

→ 源码路径：kernel/work.c 、 kernel/include/kernel.h 、 kernel/init.c

→ 关键函数：k_work_init、k_work_submit、k_work_schedule、z_work_q_main

## 源码

### main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

struct k_work my_work;
struct k_work_delayable my_delayable;

void work_handler(struct k_work *work)
{
    // 验证执行上下文：k_current_get() 应指向 system_work_q 线程
    printk("[Work] Standard work executing @ %lld ms\n", k_uptime_get());
}

void delayable_handler(struct k_work *work)
{
    // 结构体逆向获取
    struct k_work_delayable *dwork = k_work_delayable_from_work(work);
    printk("[Work] Delayable work executing @ %lld ms\n", k_uptime_get());
}

int main(void)
{
    printk("Experiment 07 - Workqueue Start\n");

    // 初始化工作项与回调绑定
    k_work_init(&my_work, work_handler);
    k_work_init_delayable(&my_delayable, delayable_handler);

    // 提交普通工作：立即排队
    k_work_submit(&my_work);

    // 提交延时工作：1000ms 后排队
    k_work_schedule(&my_delayable, K_MSEC(1000));

    return 0;
}
```

### prj.conf


```ini
CONFIG_STDOUT_CONSOLE=y
CONFIG_SYSTEM_WORKQUEUE=y
CONFIG_PRINTK=y
```

## 运行命令



```bash
west build -b qemu_cortex_m3
west build -t run
```

## 现象

1. `main` 启动并打印 ID 后立即结束。
    
2. `Standard work` 几乎立即执行，打印出不同于 `main` 的线程上下文信息。
    
3. 约 1000ms 后，`Delayable work` 准时触发打印。
    

## 坑

**现象**：`work_handler` 未被调用，没有任何输出。

**原因**：未开启 `CONFIG_SYSTEM_WORKQUEUE`，导致内核未创建系统工作线程。

**解决**：在 `prj.conf` 中显式添加 `CONFIG_SYSTEM_WORKQUEUE=y`。

---

**现象**：在 `handler` 中调用 `k_sleep` 导致其他传感器采样任务失效。

**原因**：系统工作队列是单线程串行的，任何任务阻塞都会阻塞整个队列。

**解决**：确保 `handler` 逻辑精简；耗时阻塞操作应创建自定义工作队列。

## 结论

工作队列将耗时操作从中断/高优先级线程卸载到专用后台线程，中断只需提交轻量项即可立即返回，极大提升了系统实时性。内核机制层，QEMU 与 STM32F103ZE 实板逻辑完全一致。

## 疑问与解答

**Q：中断中 submit 后 handler 何时执行？**

A：中断立即返回。`handler` 在 `system_work_q` 线程下次被调度器选中时执行（通常在所有中断处理完且没有更高优先级线程抢占时）。

---

**Q：如果工作项已经在队列中，再次 submit 会怎样？**

A：如果工作项处于 `pending` 状态（还未开始跑），重复 submit 会被忽略；如果已经在跑，再次 submit 会重新排队。

## 反哺

→ [[01-Concepts/k_work]]

→ [[01-Concepts/WorkQueue]]

---

