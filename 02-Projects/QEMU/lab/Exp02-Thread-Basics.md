# Exp02 线程基础与优先级抢占

> 日期：2026-03-20
> 目标板：qemu_cortex_m3
> 关联 Concept：[[Thread]]

## 目标

验证静态线程定义、优先级抢占机制以及 `k_msleep` 对调度的影响。

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

- Thread A（高优先级）和 Thread B（低优先级）按照各自频率交替打印
- 验证关键：如果 A 不调用 `k_msleep`，B 发生"饥饿"现象，完全无法获得执行权
- `main()` 执行完毕后内核不会停止，其他线程继续运行

---

## 坑

**现象**：修改了代码中的优先级数值，但编译出的镜像运行结果没变
**原因**：增量编译有时未能正确识别宏定义修改，或者 CMake 缓存了旧配置
**解决**：使用 `west build -p always` 强制重新配置并编译

---

## 结论

- RTOS 调度是基于优先级的抢占式调度
- `k_msleep` 是线程主动让出 CPU、进入等待状态的触发器，是实现多线程协作的基础
- `main()` 执行完毕后，内核不会停止，其他线程继续运行

---

## 疑问与解答

**Q：为什么 Thread A 和 B 的优先级相同且都不休眠时，依然能交替运行？**

A：因为 Zephyr 默认开启了 `CONFIG_TIMESLICING`（时间片轮转）。在同优先级下，内核会强行切换线程，防止某个线程无限占用 CPU。

---

**Q：如果把 Thread A 优先级设为 5，Thread B 设为 10，且 A 不休眠，B 还能跑吗？**

A：不能。抢占优先级高于时间片轮转。高优先级线程如果不阻塞或休眠，低优先级线程永远无法运行。

---

## 反哺

→ [[Thread]]
