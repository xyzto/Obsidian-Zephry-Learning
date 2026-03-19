# Zephyr RTOS 进阶：互斥量（Mutex）的核心机制与竞态条件预防

### 实验目标：规范化理解互斥量 (Mutex) 在共享资源保护中的应用

在多线程环境中，当多个线程尝试同时访问同一个非重入资源（如 I2C 总线、全局缓冲区或 UART 接口）时，会发生**竞态条件 (Race Condition)**。互斥量（Mutex）是解决这一问题的标准方案。

与你之前学习的信号量（Semaphore）不同，互斥量具有**所有权 (Ownership)** 和 **优先级继承 (Priority Inheritance)** 机制，专门用于资源保护而非线程同步。

---

### 1. 原理简述：互斥量 vs. 二值信号量

- **所有权**：只有锁定（Lock）了互斥量的线程才能解锁（Unlock）它。
    
- **优先级继承**：如果一个高优先级线程在等待一个被低优先级线程持有的互斥量，Zephyr 会临时提升低优先级线程的优先级，以防止**优先级翻转**。
    
- **递归调用**：Zephyr 的互斥量不支持递归锁定（即同一个线程不能在未解锁前再次锁定同一互斥量，除非使用特定 API）。
    

---

### 2. 关键 Kconfig 配置

互斥量是 Zephyr 内核的核心功能，通常默认开启。但如果你需要调试死锁或查看内核对象状态，可以添加：

Code snippet

```
# 启用内核对象命名，方便调试
CONFIG_THREAD_NAME=y
# 启用日志系统
CONFIG_LOG=y
```

---

### 3. Device Tree 修改 (以共享 UART 为例)

假设我们有两个线程都要向同一个 UART 接口发送数据。在 DTS 中，我们通常不需要为互斥量做特殊配置，但需要确认外设节点：

DTS

```
/ {
    chosen {
        zephyr,console = &uart0;
    };
};
```

---

### 4. C 代码实现：保护共享资源

以下代码展示了如何使用 `k_mutex` 保护一个模拟的“打印资源”，防止两个线程的字符交织在一起。

C

```
#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(mutex_demo, LOG_LEVEL_INF);

/* 1. 定义并初始化互斥量 */
K_MUTEX_DEFINE(resource_mutex);

/* 模拟一个需要受保护的硬件资源或全局变量 */
void shared_resource_access(const char *thread_name) {
    /* 2. 获取互斥量 (锁定) */
    if (k_mutex_lock(&resource_mutex, K_FOREVER) == 0) {
        
        LOG_INF("%s: 成功获取互斥量，开始访问资源...", thread_name);
        
        // 模拟耗时的硬件操作（如连续写入 I2C 寄存器）
        k_busy_wait(500000); // 占用 CPU 0.5 秒
        
        LOG_INF("%s: 资源访问完成，准备释放。", thread_name);
        
        /* 3. 释放互斥量 (解锁) */
        k_mutex_unlock(&resource_mutex);
    }
}

void thread_a_entry(void) {
    while (1) {
        shared_resource_access("Thread_A");
        k_msleep(100);
    }
}

void thread_b_entry(void) {
    while (1) {
        shared_resource_access("Thread_B");
        k_msleep(150);
    }
}

/* 静态定义两个具有相同优先级的线程 */
K_THREAD_DEFINE(thread_a_id, 1024, thread_a_entry, NULL, NULL, NULL, 7, 0, 0);
K_THREAD_DEFINE(thread_b_id, 1024, thread_b_entry, NULL, NULL, NULL, 7, 0, 0);
```

---

### 5. West 编译与验证

使用以下指令编译并观察日志。你应该能看到 Thread_A 和 Thread_B 的日志是完整成对出现的，不会出现中途插队的情况。

Bash

```
# 构建工程
west build -b <your_board> -p always
# 刷写并观察
west flash
```

---

### 排查清单：如果你的程序卡住了...

1. **检查死锁**：是否有一个线程获取了互斥量后因为某种逻辑分支没有调用 `k_mutex_unlock`？
    
2. **中断上下文限制**：**注意！** 互斥量不能在中断服务程序 (ISR) 中使用，因为 ISR 不能等待（Block）。在 ISR 中保护资源请使用原子操作或中断锁。
    

**为了使实验更贴近你的真实开发场景，请问你目前使用的硬件开发板型号是什么？** 如果是 **nRF52840**，我可以教你如何用互斥量保护特定的传感器 I2C 总线；如果是 **ESP32**，我们可以聊聊在多核环境下互斥量的特殊表现。