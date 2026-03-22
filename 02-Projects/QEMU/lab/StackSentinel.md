# 实验 10：栈溢出检测 (CONFIG_STACK_SENTINEL)

> 日期：2026-03-22
> 目标板：qemu_cortex_m3
> 关联 Concept：[[01-Concepts/StackOverflow]] | [[01-Concepts/ThreadStack]] | [[01-Concepts/MPU]]

## 目标

验证 Zephyr 软件栈哨兵机制，理解栈向下生长特性、哨兵检测时机，以及 RTOS 与裸机在栈溢出处理上的本质差异。

---

## 关键机制

**哨兵写入**：线程栈底写入固定 Magic Number，作为溢出检测的标记。

**检测时机**：不是实时监控，而是每次上下文切换（PendSV）时检查栈底值是否被覆盖——溢出发生到被检测之间存在"检测窗口"，这也是实验用 `k_yield()` 强制调度的原因。

**触发后行为**：检测到覆盖时，内核调用 `z_fatal_error()` 主动 panic，将错误控制在已知边界，不让错误扩散。

**与裸机的差异**：裸机栈溢出后悄无声息踩坏相邻内存，表现为随机数据错乱或程序跑飞，极难定位；哨兵机制虽有延时，至少给出了明确的"死亡证明"。

---

## 源码位置

→ 源码路径：`arch/arm/core/cortex_m/thread.c`、`kernel/fatal.c`
→ 关键函数：`z_check_stack_sentinel()`、`z_fatal_error()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define SMALL_STACK 512

K_THREAD_STACK_DEFINE(small_stack_area, SMALL_STACK);

void blow_stack(int iteration) {
    volatile char buffer[SMALL_STACK - 100];  /* 故意大数组，覆盖栈 */
    printk("Iteration %d, SP approx: %p\n", iteration, (void *)buffer);
    memset(buffer, 0xAA, sizeof(buffer));     /* 强制写内存 */

    if (iteration < 15) {
        k_yield();                            /* 强制调度，触发哨兵检查 */
        blow_stack(iteration + 1);
    }
}

void overflow_thread(void *p1, void *p2, void *p3) {
    ARG_UNUSED(p1); ARG_UNUSED(p2); ARG_UNUSED(p3);
    blow_stack(1);
}

K_THREAD_DEFINE(t_overflow, SMALL_STACK, overflow_thread, NULL, NULL, NULL, 5, 0, 0);

int main(void)
{
    printk("实验 10 - 栈溢出检测开始\n");
    printk("等待哨兵触发...\n");
    return 0;
}
```

### prj.conf

```ini
CONFIG_STACK_SENTINEL=y
CONFIG_PRINTK=y
CONFIG_LOG=n
```

### app.overlay（可选）

```dts
/* QEMU 实验无需 overlay */
```

---

## 运行命令

```bash
west build -b qemu_cortex_m3
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

递归深度增加，栈指针地址不断减小。在 `k_yield()` 触发调度后，内核检测到哨兵被覆盖，输出 `ZEPHYR FATAL ERROR 2: Stack overflow on CPU#0` 并附带线程信息和栈回溯，系统 panic 停止。

---

## 坑

**现象**：递归多次未触发 panic
**原因**：局部变量未实际使用被编译器优化掉，或哨兵仅在调度时检查，无调度则不触发
**解决**：加 `volatile` 防止优化，并加 `k_yield()` 强制触发调度检查

---

**现象**：panic 输出不完整
**原因**：日志未开启
**解决**：加 `CONFIG_LOG=y` 和 `CONFIG_LOG_MODE_IMMEDIATE=y`

---

## 结论

栈哨兵是软件层面的溢出防护，在线程切换时检查栈底 Magic Number，溢出后主动 panic 保护系统完整性。裸机无此机制，溢出后悄无声息踩坏内存，排查极难。换成 STM32F103ZE 实板，Cortex-M3 配备硬件 MPU，可配置栈保护区域，溢出立即触发 MemManage 异常，现场保留比软件哨兵更完整；软件哨兵需等到下次调度才检查，存在延时。

---

## 疑问与解答

**Q：哨兵检查在什么时候进行？**

A：在上下文切换（PendSV）时检查，不是实时连续检测，因此溢出到被发现之间存在一定延时，即"检测窗口"。

---

**Q：裸机栈溢出后果？**

A：无哨兵、无保护，溢出覆盖全局变量或返回地址，导致数据错乱或程序跑飞，排查极难。

---

**Q：STM32F103ZE 支持硬件栈保护吗？**

A：Cortex-M3 有 MPU，可配置栈保护区域，溢出立即触发 MemManage 异常；本实验用的是软件哨兵，实板迁移代码不变，panic 表现可能更直接（HardFault）。

---

## 反哺

→ [[01-Concepts/StackOverflow]]
→ [[01-Concepts/ThreadStack]]
→ [[01-Concepts/MPU]]
