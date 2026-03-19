# Thread（线程）

> 关联概念：[[Zephyr]] | [[Zephyr开发流程]]

## 一、线程的本质定义

> **线程是操作系统调度的最小执行单位，是程序执行流的一个实例。**

```
线程 = 指令流 + 执行上下文（PC + Registers + Stack）
```

层级关系：
```
程序 (Program) → 磁盘上的代码文件
    ↓ 运行
进程 (Process) → 正在运行的程序实例（资源容器）
    ↓ 包含
线程 (Thread) → 进程内部的执行流（执行实体）
```

---

## 二、线程的基本结构

每个线程包含：

| 组件 | 作用 |
|------|------|
| 程序计数器 (PC) | 记录下一条要执行的指令地址 |
| CPU 寄存器 | 线程切换时保存和恢复 |
| 独立栈 (Stack) | 函数调用、局部变量、返回地址 |
| 线程状态 | Running / Ready / Blocked / Terminated |

---

## 三、RTOS 中的线程（Task）

在 RTOS 中线程又称 **Task**，设计目标不是吞吐量，而是：

> **确定性（Determinism）** — 事件发生后，系统必须在确定时间内响应

RTOS 线程用线程控制块（TCB）管理：
```
TCB {
    stack_pointer
    priority
    state
    delay_ticks
}
```

### RTOS 线程状态
```
Running  → 正在占用 CPU
Ready    → 等待 CPU
Blocked  → 等待事件（信号量、队列消息）
Suspended → 被挂起
```

### 调度策略

**优先级抢占调度**（最常见）：
```
高优先级任务 Ready → 立即抢占当前运行任务
```

**时间片调度**（同优先级之间）：
```
TaskA(priority 2) → TaskB(priority 2) → TaskA → TaskB
```

---

## 四、RTOS vs 裸机

```c
// 裸机：顺序执行，无法保证实时性
while(1) {
    read_sensor();   // 如果这个卡住了
    control_motor(); // 这个就延迟了
}

// RTOS：并发执行，优先级控制响应时间
// 传感器线程 priority 3
// 电机控制线程 priority 5  ← 高优先级，始终及时响应
// 日志输出线程 priority 1
```

---

## 五、Zephyr 中的线程 API

### 创建线程（宏方式）
```c
K_THREAD_DEFINE(worker_tid,        // 线程 ID 变量名
                512,               // 栈大小（字节）
                worker_thread,     // 线程函数
                NULL, NULL, NULL,  // 参数
                5,                 // 优先级（数字越小优先级越高）
                0,                 // 选项
                0);                // 延迟启动（ms）
```

### 信号量同步
```c
K_SEM_DEFINE(my_sem, 0, 1);   // 初始值0，最大值1

// 线程 A：等待信号
void worker(void *a, void *b, void *c) {
    while (1) {
        k_sem_take(&my_sem, K_FOREVER);  // 阻塞等待
        do_work();
    }
}

// 线程 B（或主线程）：触发
k_sem_give(&my_sem);
```

### 消息队列
```c
K_MSGQ_DEFINE(my_queue, sizeof(int), 10, 4);

// 发送
int data = 42;
k_msgq_put(&my_queue, &data, K_NO_WAIT);

// 接收
int received;
k_msgq_get(&my_queue, &received, K_FOREVER);
```

### 互斥锁
```c
K_MUTEX_DEFINE(my_mutex);

k_mutex_lock(&my_mutex, K_FOREVER);
// 临界区操作
k_mutex_unlock(&my_mutex);
```

---

## 六、线程通信机制对比

| 机制 | 用途 | Zephyr API |
|------|------|-----------|
| Semaphore | 事件同步 | `k_sem` |
| Mutex | 互斥访问共享资源 | `k_mutex` |
| Message Queue | 线程间传递数据 | `k_msgq` |
| Event Flag | 多事件组合等待 | `k_event` |

---

## 七、中断与线程的配合模式

不要在中断里做复杂逻辑，用"中断发信号，线程处理"模式：
```
UART 中断触发
    ↓
k_sem_give() 或 k_msgq_put()（轻量操作，在中断里安全）
    ↓
通信线程从阻塞中唤醒
    ↓
处理复杂逻辑
```

---

## 八、注意事项

- 每个 `while(1)` 必须有 `k_sleep()` 或阻塞操作，否则线程独占 CPU，其他线程无法运行
- RTOS 线程栈大小需要手动配置，嵌入式中 RAM 有限，根据实际需求设置
- 竞态条件（Race Condition）：多线程访问共享变量时必须用 Mutex 保护
