# Thread（线程）

> 关联概念：[[Zephyr]] | [[Zephyr开发流程]]
> 最后更新：Day11

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

## 二、线程状态

```
Ready（就绪）   → 准备好，等内核分配 CPU
Running（运行） → 正在占用 CPU
Waiting（等待） → 在等事件（sleep / 信号量 / mutex）
Terminated      → 执行完毕
```

`k_msleep` 和 `k_sem_take` 都会触发 Running → Waiting 的状态切换，主动交出 CPU。

---

## 三、RTOS 调度原理

**CPU 永远不停。** 所有线程都在 sleep 时，内核运行空闲线程（Idle Thread），执行 `WFI` 进入低功耗等待。

**内核是事件驱动的，不轮询。** 只在两个瞬间工作：
- 有线程调用阻塞函数（sleep / take）时 → 切换出去
- 有事件发生（时间到 / give）时 → 切换回来

**上下文切换：** 内核保存当前线程的所有寄存器状态到堆栈，恢复时从断点继续，不重头跑。

**优先级规则：**
- 数字越小优先级越高
- 负数 = 协作式（不会被抢占）
- 正数 = 抢占式（高优先级线程就绪时立即抢占）
- **没有 `k_sleep` 的高优先级死循环会饿死低优先级线程**

**时间片轮转（CONFIG_TIMESLICING）：**
- 同优先级线程之间，内核强行按时间片切换，防止某线程独占 CPU
- 优先级不同时，抢占优先于时间片，高优先级不阻塞则低优先级永远无法运行

---

## 四、Zephyr 线程 API

### 静态定义线程（推荐）
```c
K_THREAD_DEFINE(
    worker_tid,       // 线程 ID
    512,              // 栈大小（字节）
    worker_thread,    // 入口函数
    NULL, NULL, NULL, // 参数 p1/p2/p3
    5,                // 优先级
    0,                // 选项
    0                 // 延迟启动（ms）
);
```

---

## 五、线程间通信机制

### 信号量（Semaphore）— 发通知

**用途：** A 通知 B "可以干了"，解决执行顺序问题。

```c
K_SEM_DEFINE(my_sem, 0, 1);  // 初始值0，最大值1

// 线程 B：等待
k_sem_take(&my_sem, K_FOREVER);

// 线程 A：触发
k_sem_give(&my_sem);
```

**底层机制：** 信号量结构体内含等待队列 `wait_q`。`take` 没拿到时把当前线程加入队列并挂起；`give` 时内核从队列里取出线程唤醒。内核不轮询，完全事件驱动。

**初始值为 0 的含义：** B 必须等 A 先 give，否则开机就乱跑。

### 互斥锁（Mutex）— 保护资源

**用途：** 确保同一时间只有一个线程访问共享资源（硬件外设、全局变量）。

```c
K_MUTEX_DEFINE(my_mutex);

k_mutex_lock(&my_mutex, K_FOREVER);
// 临界区：操作共享资源
k_mutex_unlock(&my_mutex);
```

**与信号量的区别：**

| | 信号量 | 互斥锁 |
|--|--------|--------|
| 所有权 | 无（A give，B take） | 有（谁锁谁解） |
| 用途 | 发通知、协调顺序 | 保护共享资源 |
| ISR 可用 | 可（give） | 不可 |
| 优先级继承 | 无 | 有（防优先级翻转） |

**不能在中断（ISR）里用 Mutex**，ISR 不能阻塞等待。

### 消息队列（Message Queue）— 传数据

**用途：** 线程间既通知又传递数据。

```c
K_MSGQ_DEFINE(my_queue, sizeof(int), 10, 4);

// 发送
int data = 42;
k_msgq_put(&my_queue, &data, K_NO_WAIT);

// 接收
int received;
k_msgq_get(&my_queue, &received, K_FOREVER);
```

---

## 六、坑

**现象**：修改了代码中的优先级数值，编译出的镜像运行结果没变
**原因**：增量编译未能正确识别宏定义修改，CMake 缓存了旧配置
**解决**：使用 `west build -p always` 强制重新配置并编译

---

## 七、学习中产生的问题

→ [[05-Questions/线程调度相关问题集]]
