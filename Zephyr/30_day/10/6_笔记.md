太棒了！你能追问到“谁先跑”和“上下文切换”的细节，说明你已经建立了**底层的并发思维**。

第九天，我们要学习 RTOS 的灵魂：**线程间通信（Inter-Thread Communication, ITC）**。

### 1. 为什么要学这个？

在第八天，你的两个线程是“聋子”和“哑巴”，各跑各的。但在真实项目中：

- **线程 A（传感器线程）**：发现有人闯入（触发中断）。
    
- **线程 B（报警线程）**：平时睡觉，等 A 发信号说“有人”才起来拉警报。
    

如果 B 还是用 `k_sleep(5000)` 傻等，万一闯入发生在第 1 秒，B 还要睡 4 秒才报警，那小偷早跑了！所以我们需要**信号量（Semaphore）**。

---

### 2. 核心武器：信号量 (Semaphore)

信号量就像一个**“投递箱”**：

1. **线程 B**：执行 `k_sem_take`。如果箱子里没东西，它就**原地坐下睡觉**（不占 CPU）。
    
2. **线程 A**：执行 `k_sem_give`。往箱子里丢一个令牌。
    
3. **结果**：内核看到箱子有东西了，立刻叫醒 B：“起来干活！”
    

---

### 3. 第九天实验：手动触发打印

我们要修改代码，让线程 B 不再自动打印，而是**当你按一下（或者 A 闪灯一次）它才打印一次。**

#### **修改 prj.conf**

（保持原样即可，确保有 `CONFIG_GPIO=y`）

#### **修改 src/main.c**

C

```
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>

/* 1. 定义一个信号量 */
/* 初始值 0（箱子空的），最大值 1 */
K_SEM_DEFINE(my_sem, 0, 1);

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(DT_ALIAS(led_status), gpios);

/* --- 线程 B：被动等待者 --- */
void thread_b_logic(void)
{
    while (1) {
        /* B 在这里死等信号量，不占 CPU 资源 */
        k_sem_take(&my_sem, K_FOREVER); 

        printk("Thread B: Received signal! Processing data...\n");
    }
}

K_THREAD_DEFINE(thread_b_id, 1024, thread_b_logic, NULL, NULL, NULL, 7, 0, 0);

/* --- 主线程 A：主动触发者 --- */
int main(void)
{
    gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);

    int count = 0;
    while (1) {
        gpio_pin_toggle_dt(&led);
        count++;

        /* 逻辑：每闪烁 3 次灯，给线程 B 发一个信号 */
        if (count % 3 == 0) {
            printk("Thread A: Sending signal to B...\n");
            k_sem_give(&my_sem); 
        }

        k_msleep(1000);
    }
    return 0;
}
```

---

### 4. 实验现象观察

当你运行 `west build -t run` 后，你会发现：

1. 前两秒，只有 Thread A 在闪灯。
    
2. 第三秒，Thread A 打印 `Sending signal...`，紧接着 **Thread B 瞬间蹦出一行** `Received signal!`。
    
3. 然后 B 又消失了，直到 A 再次闪够 3 下。
    

---

### 5. 为什么这比 `k_sleep` 高级？

- **实时性**：B 不是在轮询（Polling），而是在**阻塞（Blocking）**。一旦 A 给信号，内核在**微秒级**内就会唤醒 B。
    
- **省电/省资源**：在等待信号时，B 线程不消耗任何 CPU 指令，CPU 可以完全去跑 A 或者进入低功耗模式。
    

---

### 🚀 挑战时间

如果你已经跑通了上面的代码，尝试思考并操作：

**如果我连续快速执行两次 `k_sem_give`，B 会打印几次？**

(提示：看 `K_SEM_DEFINE` 里的最大值。如果最大值是 1，第二次 give 可能会被丢弃或者溢出，取决于你的业务逻辑。)

**实验跑通了吗？看到 A 成功“指挥” B 的那一刻了吗？**




---




完美！看到这个循环输出，说明你已经成功打通了 **Zephyr 内核最核心的通信机制之一：信号量 (Semaphore)**。

最后那个 `qemu-system-arm: terminating on signal 2` 是正常现象，那是你按了 **Ctrl+C** 强行退出模拟器的信号。

### 1. 刚才发生了什么？（底层逻辑复盘）

你刚才不仅仅是跑通了代码，而是实现了一个经典的 **生产者-消费者 (Producer-Consumer)** 模型：

- **线程 A (生产者)**：每 3 秒切换一次 LED 状态，并“生产”一个信号（`k_sem_give`）。
    
- **线程 B (消费者)**：它平时处于 **阻塞 (Blocked)** 状态，不占用 CPU 资源。直到信号量的值大于 0，内核才把它唤醒，让它打印消息。
    

---

### 2. 深度思考：如果不用信号量会怎样？

如果没有信号量，你可能得在线程 B 里写一个死循环不断检查 LED 状态：

C

```
while(1) {
    if (led_is_on) { printk(...); } 
}
```

这叫 **“忙等待” (Busy-waiting)**。在单片机里，这会 100% 榨干 CPU，导致其他任务卡顿且极其耗电。

**而你现在的写法**：线程 B 在等待时是“休眠”的，CPU 可以去处理别的事情，这才是嵌入式操作系统的精髓。

---

### 3. 下一个挑战：互斥锁 (Mutex) 的反直觉实验

信号量是“给信号”，而 **互斥锁 (Mutex)** 是“锁资源”。

想象一下：如果线程 A 和 线程 B **都想控制同一个 LED**。

- 线程 A 想让 LED 闪烁。
    
- 线程 B 想根据某个传感器数值强制关灯。
    

如果它们同时操作引脚，硬件就会发生冲突。这时候就不能用 `k_sem_give` 了，而要用 **`k_mutex_lock`**。

**你想试试把这个实验改成“抢夺 LED 控制权”的互斥锁模式吗？我可以教你如何防止两个线程把灯闪“疯”了。**