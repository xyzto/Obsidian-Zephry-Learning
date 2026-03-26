# 中断风暴 (Interrupt Storm)

> 关联概念：[[k_work]] [[k_workqueue]] [[UART FIFO]] [[DMA]] [[上/下半部]]  
> 来源问题：[[高速串口数据导致 CPU 100% 占用且主线程无法运行]]

## 本质
中断风暴是指由于外设（典型是 UART/SPI/I2C 等）产生中断的频率极高，超过 CPU 处理单个中断的开销，导致 CPU 几乎全部时间都停留在中断上下文，几乎无法执行线程代码（包括 main 线程），系统表现为“假死”或完全无响应。

## 解决什么问题
防止高频中断把 CPU 完全“淹没”，让线程上下文（包括系统 workqueue、用户线程）仍有执行机会，避免系统整体卡死或看门狗复位。

## 核心机制
中断风暴的根本原因是**中断产生速率 >> 单次中断处理耗时**  
三种主流缓解/根治方案：

1. **硬件 FIFO + 阈值触发**  
   - UART 内部硬件缓冲区（通常 8/16/32/64/128 字节不等，STM32F103 多数为 1 字节无 FIFO 或极小）  
   - 配置 RX FIFO 达到阈值（threshold）才触发一次中断  
   - 一次中断可读走多个字节，大幅降低中断频率

2. **上半部 + 下半部（Bottom Half）**  
   - 上半部（ISR）：极短，只做：读 FIFO → 存环形缓冲 → 提交 k_work / 给 semaphore / 发 event  
   - 下半部：workqueue 线程 / 专用线程 完成解析、协议处理、业务逻辑  
   - ISR 执行时间控制在 1–5 μs 级别，即使 115200bps 极限速率也留出大量空闲

3. **DMA 搬运 + 完成中断**  
   - UART TX/RX 硬件直接访问 RAM（无需 CPU 参与每字节搬运）  
   - 配置：循环模式 / 正常模式 + NDTR 计数  
   - 只在搬运完成（或半满/半空）时产生一次中断  
   - CPU 占用率接近 0%，适合 1Mbps+ 甚至更高吞吐

## 区别
- 裸机简单中断：一字节一中断 → 极易风暴  
- 裸机 + 环形缓冲 + 后台轮询：缓解但仍占用一个线程  
- Zephyr + k_work / k_msgq：ISR 极短 + 异步到线程上下文，调度器仍能正常工作  
- Zephyr + DMA：中断次数最少（可低至每包一次甚至无中断轮询），最高效

## 在 Zephyr 里怎么用

**方案1：FIFO 阈值**（STM32F103 硬件限制，基本无用或极小效果）

**方案2：中断 + k_work / k_msgq**（当前最实用）

```c
static struct k_work uart_work;
static uint8_t rx_buf[256];
static size_t rx_len;

static void uart_isr(const struct device *dev, void *user_data)
{
    while (uart_irq_update(dev) && uart_irq_is_pending(dev)) {
        if (uart_irq_rx_ready(dev)) {
            rx_len += uart_fifo_read(dev, rx_buf + rx_len, sizeof(rx_buf) - rx_len);
        }
    }
    k_work_submit(&uart_work);          // 提交一次即可（去重由 k_work 保证）
}

static void uart_work_handler(struct k_work *work)
{
    // 在 workqueue 线程里解析 rx_buf 中的 rx_len 字节
    // 处理完后可清标志或继续等待下一次
}
```

**方案3：DMA**（后续实验重点）

- 使用 `UART_DMA` 驱动或 `stm32 uart driver` 的 DMA 通道
- 配置 `uart_rx_dma` → 完成回调或中断

## 坑

**现象**：即使加了 k_work_submit，系统仍卡死  
**原因**：ISR 本身没退出（while 循环没正确 break / FIFO 没读空）  
**解决**：必须把所有 pending 数据读完再 return

**现象**：提交 k_work 后 handler 很久不执行  
**原因**：system workqueue 被其他长时间阻塞的 work 占满  
**解决**：创建专用 workqueue（k_work_queue_start）并绑定高优先级

**现象**：DMA 模式下仍频繁中断  
**原因**：用了半传输中断 + 完成中断，或 NDTR 设置太小  
**解决**：用循环模式 + 只启用传输完成中断

## 产生的问题
→ [[ISR 内未读空 FIFO 导致重复进入]]  
→ [[workqueue 被长时间 work 阻塞]]  
→ [[STM32F103 UART 是否支持 RX FIFO 阈值]]  
→ [[DMA 模式下如何处理不定长数据包]]
 