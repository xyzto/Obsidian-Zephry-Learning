# Hello World

> 日期：2026-03-20
> 目标板：qemu_cortex_m3
> 关联 Concept：[[QEMU]] | [[Zephyr启动与设备初始化]]

## 目标

在 QEMU 模拟的 Cortex-M3 平台上运行最简单的 Hello World，观察 Zephyr 的启动过程和 printk 输出。

---

## 关键机制

**启动序列**：`z_cstart()` 完成内核初始化后，调度器接管 CPU，`main()` 作为第一个用户线程被调度执行，而非直接调用——Boot Banner 先于 `main()` 打印是这一机制的直接证据。

**printk 可用时机**：不依赖 libc，直接写硬件串口，因此在内核初始化早期和中断上下文中均可使用。

**CONFIG_BOARD 来源**：编译期由 Kconfig 写入 `autoconf.h`，值即 `-b` 参数指定的 board 名称，运行时无需查询硬件。

---

## 源码位置

→ 源码路径：`kernel/init.c`
→ 关键函数：`z_cstart()`、`z_boot_banner()`、`z_thread_entry()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>

int main(void)
{
    printk("Hello World! %s\n", CONFIG_BOARD);
    return 0;
}
```

### prj.conf

```ini
# 开启打印支持（默认已开启，此处显式声明用于实验）
CONFIG_PRINTK=y
# 实验：尝试关闭启动横幅观察变化
# CONFIG_BOOT_BANNER=n
```

### app.overlay（可选）

```dts
/* QEMU 实验无需 overlay */
```

---

## 运行命令

```bash
west build -b qemu_cortex_m3 samples/hello_world
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

终端先打印启动横幅 `*** Booting Zephyr OS build vX.X.X ***`，随后输出 `Hello World! qemu_cortex_m3`，其中 board 名称由 `CONFIG_BOARD` 宏在编译期注入。Banner 先于 `main()` 打印，验证了内核初始化在进入 `main` 前已完成。

![[Pasted image 20260320090403.png]]

---

## 坑

---

## 结论

Zephyr 的启动流程是"内核初始化 → 调度器启动 → main() 作为线程被调度"，`main()` 不是程序入口而是第一个用户线程。换成 STM32F103ZE 实板，内核启动机制与 QEMU 完全一致，无迁移成本。

---

## 疑问与解答

**Q：启动时打印的 `*** Booting Zephyr OS ***` 是什么，在 `main()` 之前还是之后？**

A：是 Boot Banner，由内核初始化序列中的 `z_boot_banner()` 打印，发生在 `main()` 之前。`main()` 是内核初始化完成后才被调度运行的第一个用户线程，Banner 打印时它还没有执行。

---

**Q：`printk` 和标准 `printf` 有什么区别？**

A：`printk` 不依赖 C 标准库（libc），不需要堆内存，可以在内核初始化早期和中断上下文中使用。`printf` 依赖 libc，资源占用更大。Zephyr 的 `printk` 是轻量级替代品，足够调试用。

---

**Q：`prj.conf` 里不加 `CONFIG_PRINTK=y` 会怎样？**

A：`printk` 调用会被编译为空操作（no-op），代码能正常编译，但不会有任何输出。这是 Kconfig 机制的体现——未开启的功能在编译期就被裁掉，不占用 Flash 空间。

---

**Q：`CONFIG_BOARD` 这个宏是哪里来的？**

A：由 Kconfig 构建系统在编译阶段自动生成，写入 `build/zephyr/include/generated/autoconf.h`，值就是 `-b` 参数指定的 board 名称。硬件信息在编译期确定，不在运行时查询。

---

## 反哺

→ [[01-Concepts/QEMU]]
→ [[01-Concepts/Zephyr启动与设备初始化]]
