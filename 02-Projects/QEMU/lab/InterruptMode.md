# 实验13 UART 中断（Interrupt Mode）

> 日期：2026-03-22  
> 目标板：qemu_cortex_m3  
> 关联 Concept：[[01-Concepts/UART]] [[01-Concepts/InterruptHandling]] [[01-Concepts/DriverModel]]

## 目标

掌握 Zephyr UART 中断驱动模型，实现异步接收，理解中断回调的上下文限制及 uart_irq_update 的必要性。

## 关键机制

**异步通知**：硬件接收数据后触发 IRQ，驱动 irq_handler 调用注册的回调函数。

**状态同步**：必须调用 uart_irq_update() 刷新驱动内部状态位，否则 rx_ready 等判断失效。

**FIFO 读取**：回调中使用 uart_fifo_read() 非阻塞读取硬件缓冲区数据。

**中断上下文限制**：回调运行在中断上下文，严禁延时、printk、阻塞 API，否则导致 FIFO 溢出（Overrun）或死锁。

**回调注册**：uart_irq_callback_user_data_set 或 uart_irq_callback_set，内核自动挂载 NVIC。

## 源码位置

→ 源码路径：include/zephyr/drivers/uart.h 、 drivers/serial/uart_qemu.c（QEMU）、drivers/serial/uart_stm32.c（实板）  
→ 关键函数：uart_irq_callback_set 、 uart_irq_rx_enable 、 uart_irq_update 、 uart_fifo_read

## 源码

### main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>

#define UART_NODE DT_CHOSEN(zephyr_console)

void uart_cb(const struct device *dev, void *user_data)
{
    uint8_t c;
    uart_irq_update(dev);

    while (uart_irq_is_pending(dev)) {
        if (uart_irq_rx_ready(dev)) {
            while (uart_fifo_read(dev, &c, 1) > 0) {
                uart_poll_out(dev, '>');   // 中断内简单回显
                uart_poll_out(dev, c);
            }
        } else {
            break;
        }
    }
}

int main(void)
{
    const struct device *dev = DEVICE_DT_GET(UART_NODE);
    if (!device_is_ready(dev)) return 0;

    uart_irq_callback_set(dev, uart_cb, NULL);
    uart_irq_rx_enable(dev);

    while (1) {
        k_sleep(K_FOREVER);  // 主线程休眠
    }
}
```

### prj.conf

```ini
CONFIG_SERIAL=y
CONFIG_UART_INTERRUPT_DRIVEN=y
```

## 运行命令

```bash
west build -b qemu_cortex_m3
west build -t run
```

## 现象

终端输入字符，立即回显 >字符。主线程 K_FOREVER 睡眠，CPU 空闲。删除 k_sleep 改 busy_wait 会显著增加 CPU 占用。

## 坑

**现象**：回调不触发或 uart_irq_rx_ready 始终 false  
**原因**：未调用 uart_irq_update() 或未开启 CONFIG_UART_INTERRUPT_DRIVEN  
**解决**：回调首行加 uart_irq_update；prj.conf 开启中断驱动配置

**现象**：输入字符丢失或出现 Overrun  
**原因**：回调内执行耗时操作（如 printk、延时）  
**解决**：回调保持极简，仅读取数据；耗时任务丢给线程或队列处理

## 结论

Zephyr UART 中断模式通过回调实现异步接收，uart_irq_update 是跨平台驱动的强制要求，确保状态同步。回调运行在中断上下文，严禁阻塞操作，避免 FIFO 溢出。  
实板迁移需 overlay 启用 USART、pinctrl、irq 配置，代码逻辑不变，但需注意中断优先级和 FIFO 深度。

## 疑问与解答

**Q：为什么必须调用 uart_irq_update？**  
A：刷新驱动内部中断状态位，否则 rx_ready 等宏无法正确判断硬件事件（兼容不同硬件的“读后清”或只读寄存器）。

**Q：回调里为什么不能用 printk？**  
A：printk 可能涉及互斥锁或格式化，在中断上下文调用易死锁或时序混乱。

**Q：实板连续发送 “Hello” 会怎样？**  
A：中断处理慢会导致硬件 FIFO 溢出（Overrun），后续字节被丢弃，只收到部分字符。

## 反哺

→ [[01-Concepts/UART]]  
→ [[01-Concepts/InterruptHandling]]  
→ [[01-Concepts/DriverModel]]

笔记已生成，可直接落地。  
想继续下一个实验（14 GPIO 模拟）就说“已落地”或“下一个”。