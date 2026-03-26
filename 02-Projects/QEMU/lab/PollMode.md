# 实验12 UART 基础（Poll Mode 轮询收发）

> 日期：2026-03-22  
> 目标板：qemu_cortex_m3  
> 关联 Concept：[[01-Concepts/UART]] [[01-Concepts/DriverModel]] [[01-Concepts/PollMode]] [[01-Concepts/DeviceTree]]

## 目标

掌握 Zephyr UART 轮询模式收发，理解设备抽象层（DEVICE_DT_GET）屏蔽寄存器细节的机制，以及 Poll 模式在多线程环境下的 CPU 占用问题。

## 关键机制

**设备抽象**：DEVICE_DT_GET 从设备树获取 UART 实例，屏蔽底层寄存器地址和芯片差异。

**非阻塞接收**：uart_poll_in 检查状态位（RXNE/DR），有数据返回 0，无数据立即返回 -1。

**轮询发送**：uart_poll_out 检查 TXE 位，空闲时写入数据寄存器。

**控制台解耦**：printk 底层可挂接 uart_poll_out（CONFIG_UART_CONSOLE=y），本实验直接调用 API 验证底层逻辑。

**CPU 释放**：循环中加 k_msleep 避免 100% 占用 CPU。

## 源码位置

→ 源码路径：include/zephyr/drivers/uart.h 、 drivers/serial/uart_qemu.c（QEMU）、drivers/serial/uart_stm32.c（实板）  
→ 关键函数：DEVICE_DT_GET 、 uart_poll_in 、 uart_poll_out

## 源码

### main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>

#define UART_DEVICE_NODE DT_CHOSEN(zephyr_console)

int main(void)
{
    const struct device *uart_dev = DEVICE_DT_GET(UART_DEVICE_NODE);
    char recv_char;

    if (!device_is_ready(uart_dev)) {
        printk("UART 未就绪\n");
        return 0;
    }

    printk("实验 12 - UART Poll 模式\n");
    printk("输入字符将回显 [字符]\n");

    while (1) {
        if (uart_poll_in(uart_dev, &recv_char) == 0) {
            uart_poll_out(uart_dev, '[');
            uart_poll_out(uart_dev, recv_char);
            uart_poll_out(uart_dev, ']');
            uart_poll_out(uart_dev, '\n');
        }
        k_msleep(10);
    }
}
```

### prj.conf

```ini
CONFIG_SERIAL=y
CONFIG_UART=y
CONFIG_UART_CONSOLE=y
CONFIG_PRINTK=y
```

## 运行命令

```bash
west build -b qemu_cortex_m3
west build -t run
```

## 现象

QEMU telnet localhost 1234 输入字符，立即回显 [字符] + 换行。无输入时循环等待，CPU 不被 100% 占用。

## 坑

**现象**：DEVICE_DT_GET 返回 NULL 或未就绪  
**原因**：设备树 chosen/zephyr,console 未指向 uart0，或节点 status="disabled"  
**解决**：检查 board.dts 或 app.overlay 激活对应 UART

**现象**：输入无响应或乱码  
**原因**：QEMU 串口未连接，或实板波特率未匹配  
**解决**：telnet localhost 1234 连接；实板 overlay 设置 current-speed = <115200>

## 结论

Zephyr UART Poll 模式底层直接读写状态/数据寄存器，非阻塞设计需主动轮询。驱动模型 + 设备树实现硬件抽象，代码不依赖具体寄存器地址。  
实板迁移需 overlay 启用 USART、配置 pinctrl（GPIO AF）、设置波特率，prj.conf 加 STM32 特定选项。

## 疑问与解答

**Q：uart_poll_in 为什么返回 -1 而不是阻塞？**  
A：Poll 模式设计为非阻塞，便于多任务轮询；阻塞场景用中断或信号量。

**Q：为什么循环要加 k_msleep(10)？**  
A：避免单线程 100% 占用 CPU，导致同优先级或其他线程无法调度。

**Q：裸机 Poll 与 Zephyr Poll 区别？**  
A：裸机需手动 RCC/GPIO/波特率；Zephyr 驱动自动初始化，你只调用 API。

## 反哺

→ [[01-Concepts/UART]]  
→ [[01-Concepts/DriverModel]]  
→ [[01-Concepts/PollMode]]  
→ [[01-Concepts/DeviceTree]]

