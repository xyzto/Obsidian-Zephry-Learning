# 30天Zephyr工程师训练计划

## 前言

Zephyr RTOS 是由 Linux 基金会托管的开源实时操作系统，专为资源受限的物联网设备设计。它支持多种硬件架构（包括 x86、ARM、RISC-V 等），具有高度可配置性、极小的内存占用和丰富的生态系统，目前被广泛应用于可穿戴设备、工业传感器、智能家居、汽车电子等物联网领域，是现代嵌入式开发的重要选择。

本训练计划针对已部署好 Docker + VS Code Zephyr 环境，但零硬件或刚开始考虑买板的开发者设计，通过 30 天的系统学习，帮助您从零基础成长为能够独立开发 Zephyr 应用的工程师。每日建议学习时长为 2-3 小时，您可以根据自身情况灵活调整。

## 准备工作

### 已完成的环境要求

- Docker + VS Code Zephyr 开发环境已部署完成
    
- 具备基本的 C 语言编程基础
    
- 了解嵌入式开发的基本概念（如寄存器、外设、实时操作系统基础概念）
    

### 硬件准备建议

- 入门推荐：BBC micro:bit v2（价格便宜，支持完善，无需额外调试工具，适合新手入门）
    
- 进阶推荐：nRF52840 DK（Nordic 开发板，支持蓝牙 5.0，外设丰富，适合开发蓝牙相关应用）
    
- 经济选择：ESP32-C3 开发板（乐鑫芯片，支持 WiFi 和蓝牙，性价比高，适合物联网应用开发）
    
- 专业级：STM32F4Discovery（性能较强，适合复杂嵌入式应用开发）
    

### 环境验证步骤

在开始学习前，请先验证您的开发环境是否可用：

```bash

# 查看west版本，确认工具链正常
west --version
# 查看Zephyr支持的开发板列表，确认环境配置正确
west boards
```

## 第 1-7 天：基础入门周

### 学习目标

掌握 Zephyr 的基础概念、项目结构、构建系统和基本工具使用，能够完成简单的 Zephyr 项目创建和仿真运行。

---

#### 第 1 天：Zephyr 生态系统了解

**学习目标**：理解 Zephyr 的核心概念和生态系统  
**今日任务**：

1. 阅读 Zephyr 官方文档的 "Getting Started" 部分
    
2. 了解 Zephyr 的历史、特点和应用场景
    
3. 熟悉 Zephyr 的架构设计理念
    
4. 查看 Zephyr 支持的开发板列表
    
5. 练习使用 west 工具的基本命令
    

**实践操作**：

```bash

# 查看west版本
west --version

# 查看Zephyr支持的开发板
west boards

# 查看当前工作状态
west status
```

**学习资源**：

- [Zephyr 官方文档](https://docs.zephyrproject.org/)
    
- [Zephyr GitHub 仓库](https://github.com/zephyrproject-rtos/zephyr)
    

**学习打卡**：□ 完成文档阅读 □ 完成 west 命令练习 □ 记录 Zephyr 的 3 个核心特点

---

#### 第 2 天：项目结构和构建系统

**学习目标**：掌握 Zephyr 项目结构和构建流程  
**今日任务**：

1. 理解 Zephyr 的项目组织结构
    
2. 学习 CMakeLists.txt 文件的编写规则
    
3. 了解 prj.conf 配置文件的作用
    
4. 掌握 west build 命令的使用方法
    
5. 学习设备树 (Devicetree) 的基本概念
    

**实践操作**：

```bash

# 创建第一个Hello World项目
west init -m https://github.com/zephyrproject-rtos/zephyr --mr main zephyrproject
cd zephyrproject

# 更新项目依赖
west update

# 构建并运行Hello World示例(QEMU仿真)
west build -b qemu_x86 samples/hello_world
west build -t run
```

**学习资源**：

- [Zephyr 构建系统文档](https://docs.zephyrproject.org/latest/build/index.html)
    
- [CMake 基础教程](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
    

**学习打卡**：□ 完成 Hello World 项目创建 □ 理解项目各目录作用 □ 记录 prj.conf 的 3 个基础配置项

---

#### 第 3 天：Hello World 深入分析

**学习目标**：深入理解 Zephyr 应用的基本结构  
**今日任务**：

1. 分析 Hello World 示例的代码结构
    
2. 理解 Zephyr 的启动流程
    
3. 学习 printk 函数的使用
    
4. 了解 Zephyr 的内核初始化过程
    
5. 练习修改和重新构建项目
    

**实践操作**：

```c

// 修改samples/hello_world/src/main.c文件
#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

void main(void)
{
	printk("Hello Zephyr World! %s\n", CONFIG_BOARD);

	for (int i = 0; i < 10; i++) {
		k_sleep(K_SECONDS(1));
		printk("Count: %d\n", i);
	}
}
```

修改完成后重新构建运行：

```bash

west build -b qemu_x86 samples/hello_world
west build -t run
```

**学习打卡**：□ 分析完 Hello World 代码结构 □ 完成代码修改并运行成功 □ 理解 Zephyr 的启动流程

---

#### 第 4 天：QEMU 仿真环境使用

**学习目标**：熟练使用 QEMU 进行 Zephyr 应用仿真  
**今日任务**：

1. 学习 QEMU 的基本使用方法
    
2. 了解不同架构的 QEMU 仿真目标
    
3. 练习在 QEMU 中运行和调试 Zephyr 应用
    
4. 学习使用串口终端查看输出
    
5. 了解仿真环境与真实硬件的差异
    

**实践操作**：

```bash

# 运行x86架构仿真
west build -b qemu_x86 samples/hello_world
west build -t run

# 运行ARM Cortex-M3仿真
west build -b qemu_cortex_m3 samples/basic/blinky
west build -t run

# 查看串口输出（如果是真实硬件连接时使用）
minicom -D /dev/ttyACM0 -b 115200
```

**学习打卡**：□ 完成两种架构的仿真运行 □ 理解仿真与真实硬件的差异 □ 掌握串口查看输出的方法

---

#### 第 5 天：Kconfig 配置系统

**学习目标**：掌握 Zephyr 的配置系统  
**今日任务**：

1. 理解 Kconfig 的工作原理
    
2. 学习 prj.conf 文件的配置语法
    
3. 了解 menuconfig 的使用方法
    
4. 练习启用和禁用不同的内核功能
    
5. 学习配置片段 (config fragments) 的使用
    

**实践操作**：

```bash

# 打开配置菜单
west build -t menuconfig

# 查看当前配置
west build -t config

# 创建配置片段
cat > my_config.conf << EOF
CONFIG_CONSOLE=y
CONFIG_SERIAL=y
CONFIG_LOG=y
EOF

# 使用配置片段构建项目
west build -b qemu_x86 samples/hello_world -- -DCONFIG_FILES=my_config.conf
```

**学习打卡**：□ 完成 menuconfig 的使用练习 □ 创建并使用配置片段 □ 记录 3 个常用的 Kconfig 配置项

---

#### 第 6 天：设备树基础

**学习目标**：理解 Zephyr 设备树的概念和使用  
**今日任务**：

1. 学习设备树的基本语法和结构
    
2. 理解设备树在 Zephyr 中的作用
    
3. 学习设备树覆盖 (overlay) 的使用
    
4. 练习编写简单的设备树覆盖文件
    
5. 了解设备树与驱动的关系
    

**实践操作**：

```dts

// 创建设备树覆盖文件 app.overlay
/ {
	chosen {
		zephyr,console = &uart0;
		zephyr,shell-uart = &uart0;
	};
};

&uart0 {
	status = "okay";
	current-speed = <115200>;
};
```

使用设备树覆盖构建项目：

```bash

west build -b qemu_x86 samples/hello_world -- -DDTC_OVERLAY_FILE=app.overlay
```

**学习打卡**：□ 完成设备树覆盖文件编写 □ 理解设备树的作用 □ 掌握设备树覆盖的使用方法

---

#### 第 7 天：基础实验总结

**学习目标**：巩固本周学习内容，完成综合小实验  
**今日任务**：

1. 回顾本周学习的所有内容
    
2. 完成一个综合小实验：创建一个带自定义配置和设备树覆盖的 Hello World 应用
    
3. 练习使用不同的构建选项
    
4. 学习如何查看和分析构建输出
    
5. 总结学习过程中遇到的问题和解决方法
    

**实践操作**：

```bash

# 创建自定义项目
west init my_zephyr_project
cd my_zephyr_project
west update

# 在项目中创建prj.conf文件
cat > prj.conf << EOF
CONFIG_CONSOLE=y
CONFIG_LOG=y
CONFIG_SERIAL=y
EOF

# 在项目中创建app.overlay文件
cat > app.overlay << EOF
/ {
	chosen {
		zephyr,console = &uart0;
	};
};

&uart0 {
	status = "okay";
	current-speed = <115200>;
};
EOF

# 构建带自定义配置的项目
west build -b qemu_x86 -- -DCONFIG_MY_FEATURE=y
west build -t run
```

**本周总结**：

1. 整理本周学习的核心知识点
    
2. 记录遇到的问题和解决方法
    
3. 评估自己的掌握程度，确定下周的学习重点
    

---

## 第 8-14 天：内核深入周

### 学习目标

掌握 Zephyr 内核的核心功能，包括线程管理、同步机制、定时器等，能够编写多线程的 Zephyr 应用。

---

#### 第 8 天：线程管理基础

**学习目标**：理解 Zephyr 的线程管理机制  
**今日任务**：

1. 学习 Zephyr 线程的基本概念
    
2. 理解线程的生命周期和状态转换
    
3. 学习 k_thread_create 函数的使用
    
4. 了解线程优先级的概念
    
5. 练习创建和管理多个线程
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024
#define THREAD_PRIORITY 5

K_THREAD_STACK_DEFINE(my_stack_area, STACK_SIZE);
struct k_thread my_thread_data;

void my_thread_func(void *p1, void *p2, void *p3)
{
	while (1) {
		printk("Thread running...\n");
		k_sleep(K_SECONDS(2));
	}
}

void main(void)
{
	// 创建线程
	k_thread_create(&my_thread_data, my_stack_area,
			K_THREAD_STACK_SIZEOF(my_stack_area),
			my_thread_func, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	while (1) {
		printk("Main thread running...\n");
		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成线程创建代码编写 □ 理解线程生命周期 □ 掌握 k_thread_create 的使用

---

#### 第 9 天：线程调度和优先级

**学习目标**：掌握 Zephyr 线程调度机制和优先级管理  
**今日任务**：

1. 学习线程优先级的设置和影响
    
2. 了解抢占式调度的概念
    
3. 练习使用 k_yield () 和 k_sleep () 函数
    
4. 学习线程挂起和恢复的操作
    
5. 理解调度策略对应用的影响
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024
#define HIGH_PRIORITY 3
#define LOW_PRIORITY 5

K_THREAD_STACK_DEFINE(high_stack_area, STACK_SIZE);
struct k_thread high_thread_data;

K_THREAD_STACK_DEFINE(low_stack_area, STACK_SIZE);
struct k_thread low_thread_data;

void high_prio_thread(void *p1, void *p2, void *p3)
{
	while (1) {
		printk("High priority thread running...\n");
		k_sleep(K_SECONDS(2));
	}
}

void low_prio_thread(void *p1, void *p2, void *p3)
{
	while (1) {
		printk("Low priority thread running...\n");
		k_yield(); // 让出CPU
		k_sleep(K_SECONDS(1));
	}
}

void main(void)
{
	// 创建高优先级线程
	k_thread_create(&high_thread_data, high_stack_area,
			K_THREAD_STACK_SIZEOF(high_stack_area),
			high_prio_thread, NULL, NULL, NULL,
			HIGH_PRIORITY, 0, K_NO_WAIT);

	// 创建低优先级线程
	k_thread_create(&low_thread_data, low_stack_area,
			K_THREAD_STACK_SIZEOF(low_stack_area),
			low_prio_thread, NULL, NULL, NULL,
			LOW_PRIORITY, 0, K_NO_WAIT);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成线程优先级实验 □ 理解抢占式调度 □ 掌握 k_yield () 的使用

---

#### 第 10 天：信号量

**学习目标**：掌握 Zephyr 信号量的使用  
**今日任务**：

1. 理解信号量的工作原理
    
2. 学习 k_sem_init ()、k_sem_give () 和 k_sem_take () 函数
    
3. 练习使用信号量实现线程同步
    
4. 了解信号量的计数特性
    
5. 学习信号量在中断中的使用
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024
#define THREAD_PRIORITY 5

K_THREAD_STACK_DEFINE(thread_stack_area, STACK_SIZE);
struct k_thread thread_data;

struct k_sem sem;

void sem_thread(void *p1, void *p2, void *p3)
{
	printk("Thread waiting for semaphore...\n");
	// 获取信号量
	k_sem_take(&sem, K_FOREVER);
	printk("Thread got semaphore, running...\n");

	while (1) {
		printk("Thread running with semaphore...\n");
		k_sleep(K_SECONDS(1));
	}
}

void main(void)
{
	// 初始化信号量，初始计数为0
	k_sem_init(&sem, 0, 1);

	// 创建线程
	k_thread_create(&thread_data, thread_stack_area,
			K_THREAD_STACK_SIZEOF(thread_stack_area),
			sem_thread, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	k_sleep(K_SECONDS(3));
	// 释放信号量
	printk("Giving semaphore...\n");
	k_sem_give(&sem);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成信号量同步实验 □ 理解信号量的计数特性 □ 掌握信号量在线程同步中的使用

---

#### 第 11 天：互斥锁

**学习目标**：掌握 Zephyr 互斥锁的使用  
**今日任务**：

1. 理解互斥锁的工作原理
    
2. 学习 k_mutex_init ()、k_mutex_lock () 和 k_mutex_unlock () 函数
    
3. 练习使用互斥锁保护共享资源
    
4. 了解互斥锁的优先级继承特性
    
5. 对比信号量和互斥锁的使用场景
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024
#define THREAD_PRIORITY 5

K_THREAD_STACK_DEFINE(thread1_stack_area, STACK_SIZE);
struct k_thread thread1_data;

K_THREAD_STACK_DEFINE(thread2_stack_area, STACK_SIZE);
struct k_thread thread2_data;

struct k_mutex mutex;
int shared_resource = 0;

void thread1_func(void *p1, void *p2, void *p3)
{
	while (1) {
		k_mutex_lock(&mutex, K_FOREVER);
		shared_resource++;
		printk("Thread1: shared_resource = %d\n", shared_resource);
		k_mutex_unlock(&mutex);
		k_sleep(K_SECONDS(1));
	}
}

void thread2_func(void *p1, void *p2, void *p3)
{
	while (1) {
		k_mutex_lock(&mutex, K_FOREVER);
		shared_resource--;
		printk("Thread2: shared_resource = %d\n", shared_resource);
		k_mutex_unlock(&mutex);
		k_sleep(K_SECONDS(1));
	}
}

void main(void)
{
	k_mutex_init(&mutex);

	k_thread_create(&thread1_data, thread1_stack_area,
			K_THREAD_STACK_SIZEOF(thread1_stack_area),
			thread1_func, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	k_thread_create(&thread2_data, thread2_stack_area,
			K_THREAD_STACK_SIZEOF(thread2_stack_area),
			thread2_func, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成互斥锁实验 □ 理解优先级继承特性 □ 掌握互斥锁与信号量的区别

---

#### 第 12 天：消息队列

**学习目标**：掌握 Zephyr 消息队列的使用  
**今日任务**：

1. 理解消息队列的工作原理
    
2. 学习 k_msgq_init ()、k_msgq_put () 和 k_msgq_get () 函数
    
3. 练习使用消息队列实现线程间通信
    
4. 了解消息队列的容量和消息大小设置
    
5. 学习消息队列的超时处理
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024
#define THREAD_PRIORITY 5

#define MSGQ_SIZE 5
#define MSG_SIZE sizeof(int)

K_THREAD_STACK_DEFINE(sender_stack_area, STACK_SIZE);
struct k_thread sender_data;

K_THREAD_STACK_DEFINE(receiver_stack_area, STACK_SIZE);
struct k_thread receiver_data;

struct k_msgq msgq;
char msgq_buffer[MSGQ_SIZE * MSG_SIZE];

void sender_thread(void *p1, void *p2, void *p3)
{
	int msg = 0;
	while (1) {
		msg++;
		printk("Sending message: %d\n", msg);
		k_msgq_put(&msgq, &msg, K_NO_WAIT);
		k_sleep(K_SECONDS(1));
	}
}

void receiver_thread(void *p1, void *p2, void *p3)
{
	int msg;
	while (1) {
		k_msgq_get(&msgq, &msg, K_FOREVER);
		printk("Received message: %d\n", msg);
	}
}

void main(void)
{
	k_msgq_init(&msgq, msgq_buffer, MSG_SIZE, MSGQ_SIZE);

	k_thread_create(&sender_data, sender_stack_area,
			K_THREAD_STACK_SIZEOF(sender_stack_area),
			sender_thread, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	k_thread_create(&receiver_data, receiver_stack_area,
			K_THREAD_STACK_SIZEOF(receiver_stack_area),
			receiver_thread, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成消息队列通信实验 □ 理解消息队列的容量设置 □ 掌握消息队列的超时处理

---

#### 第 13 天：定时器和工作队列

**学习目标**：掌握 Zephyr 定时器和工作队列的使用  
**今日任务**：

1. 理解 Zephyr 定时器的工作原理
    
2. 学习 k_timer_init ()、k_timer_start () 和 k_timer_stop () 函数
    
3. 了解工作队列的概念和作用
    
4. 练习使用定时器和工作队列
    
5. 学习延迟工作的使用方法
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

struct k_timer my_timer;
struct k_work my_work;

void work_handler(struct k_work *work)
{
	printk("Work handler executed!\n");
}

void timer_handler(struct k_timer *timer)
{
	printk("Timer expired, submitting work...\n");
	k_work_submit(&my_work);
}

void main(void)
{
	// 初始化工作
	k_work_init(&my_work, work_handler);

	// 初始化定时器
	k_timer_init(&my_timer, timer_handler, NULL);

	// 启动定时器，每2秒触发一次
	k_timer_start(&my_timer, K_SECONDS(2), K_SECONDS(2));

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成定时器和工作队列实验 □ 理解工作队列的作用 □ 掌握延迟工作的使用

---

#### 第 14 天：内核功能综合实验

**学习目标**：综合运用本周学习的内核功能  
**今日任务**：

1. 回顾本周学习的所有内核对象
    
2. 设计一个综合实验，包含线程、信号量、互斥锁、消息队列
    
3. 练习调试和优化内核应用
    
4. 学习性能分析的基本方法
    
5. 总结内核编程的最佳实践
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define STACK_SIZE 1024
#define THREAD_PRIORITY 5

// 定义共享资源和同步对象
struct k_mutex mutex;
struct k_sem sem;
struct k_msgq msgq;
char msgq_buffer[5 * sizeof(int)];

// 线程栈定义
K_THREAD_STACK_DEFINE(producer_stack, STACK_SIZE);
struct k_thread producer_thread;

K_THREAD_STACK_DEFINE(consumer_stack, STACK_SIZE);
struct k_thread consumer_thread;

K_THREAD_STACK_DEFINE(worker_stack, STACK_SIZE);
struct k_thread worker_thread;

int shared_counter = 0;

void producer_func(void *p1, void *p2, void *p3)
{
	int msg = 0;
	while (1) {
		// 生产消息
		msg++;
		k_msgq_put(&msgq, &msg, K_NO_WAIT);
		printk("Producer: sent message %d\n", msg);

		// 更新共享计数器
		k_mutex_lock(&mutex, K_FOREVER);
		shared_counter++;
		printk("Producer: shared_counter = %d\n", shared_counter);
		k_mutex_unlock(&mutex);

		k_sleep(K_SECONDS(1));
	}
}

void consumer_func(void *p1, void *p2, void *p3)
{
	int msg;
	while (1) {
		k_msgq_get(&msgq, &msg, K_FOREVER);
		printk("Consumer: received message %d\n", msg);

		// 发送信号量通知工作线程
		k_sem_give(&sem);
		k_sleep(K_SECONDS(2));
	}
}

void worker_func(void *p1, void *p2, void *p3)
{
	while (1) {
		k_sem_take(&sem, K_FOREVER);
		printk("Worker: processing task...\n");

		// 读取共享计数器
		k_mutex_lock(&mutex, K_FOREVER);
		printk("Worker: shared_counter = %d\n", shared_counter);
		k_mutex_unlock(&mutex);

		k_sleep(K_SECONDS(1));
	}
}

void main(void)
{
	// 初始化同步对象
	k_mutex_init(&mutex);
	k_sem_init(&sem, 0, 5);
	k_msgq_init(&msgq, msgq_buffer, sizeof(int), 5);

	// 创建线程
	k_thread_create(&producer_thread, producer_stack,
			K_THREAD_STACK_SIZEOF(producer_stack),
			producer_func, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	k_thread_create(&consumer_thread, consumer_stack,
			K_THREAD_STACK_SIZEOF(consumer_stack),
			consumer_func, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	k_thread_create(&worker_thread, worker_stack,
			K_THREAD_STACK_SIZEOF(worker_stack),
			worker_func, NULL, NULL, NULL,
			THREAD_PRIORITY, 0, K_NO_WAIT);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**本周总结**：

1. 整理本周学习的内核核心知识点
    
2. 记录内核编程中遇到的问题和解决方法
    
3. 总结内核同步机制的使用场景和最佳实践
    

---

## 第 15-21 天：外设驱动周

### 学习目标

掌握 Zephyr 各类外设驱动的开发和使用，能够实现 GPIO、UART、I2C、SPI、PWM、ADC 等外设的控制和通信。

---

#### 第 15 天：GPIO 驱动

**学习目标**：掌握 Zephyr GPIO 驱动的使用  
**今日任务**：

1. 理解 Zephyr GPIO 子系统的架构
    
2. 学习 GPIO 设备的访问方法
    
3. 练习使用 GPIO 控制 LED
    
4. 学习 GPIO 中断的使用方法
    
5. 练习使用 GPIO 按键输入
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/sys/printk.h>

// 定义LED和按键的设备和引脚
#define LED_NODE DT_ALIAS(led0)
#define KEY_NODE DT_ALIAS(sw0)

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED_NODE, gpios);
static const struct gpio_dt_spec key = GPIO_DT_SPEC_GET(KEY_NODE, gpios);

static struct gpio_callback key_cb_data;

void key_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	printk("Key pressed!\n");
	// 翻转LED状态
	gpio_pin_toggle_dt(&led);
}

void main(void)
{
	int ret;

	// 检查设备是否就绪
	if (!device_is_ready(led.port) || !device_is_ready(key.port)) {
		printk("Device not ready!\n");
		return;
	}

	// 配置LED为输出
	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		printk("Failed to configure LED!\n");
		return;
	}

	// 配置按键为输入，带中断
	ret = gpio_pin_configure_dt(&key, GPIO_INPUT | GPIO_INT_EDGE_TO_ACTIVE);
	if (ret < 0) {
		printk("Failed to configure key!\n");
		return;
	}

	// 配置按键中断回调
	gpio_init_callback(&key_cb_data, key_pressed, BIT(key.pin));
	ret = gpio_add_callback(key.port, &key_cb_data);
	if (ret < 0) {
		printk("Failed to add key callback!\n");
		return;
	}

	// 启用中断
	ret = gpio_pin_interrupt_configure_dt(&key, GPIO_INT_EDGE_TO_ACTIVE);
	if (ret < 0) {
		printk("Failed to enable key interrupt!\n");
		return;
	}

	while (1) {
		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成 LED 控制实验 □ 完成按键中断实验 □ 掌握 GPIO 子系统的使用

---

#### 第 16 天：UART 串口通信

**学习目标**：掌握 Zephyr UART 驱动的使用  
**今日任务**：

1. 理解 Zephyr UART 子系统的架构
    
2. 学习 UART 设备的配置和使用
    
3. 练习 UART 收发数据
    
4. 学习中断驱动的 UART 通信
    
5. 掌握 UART 的参数配置
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/uart.h>
#include <zephyr/sys/printk.h>
#include <string.h>

// 定义UART设备
#define UART_DEVICE_NODE DT_CHOSEN(zephyr_shell_uart)
static const struct device *uart_dev = DEVICE_DT_GET(UART_DEVICE_NODE);

// 接收缓冲区
#define RX_BUF_SIZE 64
static uint8_t rx_buf[RX_BUF_SIZE];
static size_t rx_buf_pos;

// UART中断回调
void uart_cb(const struct device *dev, void *user_data)
{
	uint8_t c;

	while (uart_poll_in(dev, &c) == 0) {
		if (c == '\n' || c == '\r') {
			// 接收到换行符，处理数据
			printk("Received: %.*s\n", rx_buf_pos, rx_buf);
			rx_buf_pos = 0;
		} else if (rx_buf_pos < RX_BUF_SIZE - 1) {
			rx_buf[rx_buf_pos++] = c;
		}
	}
}

void main(void)
{
	int ret;

	if (!device_is_ready(uart_dev)) {
		printk("UART device not ready!\n");
		return;
	}

	// 配置UART
	const struct uart_config uart_cfg = {
		.baudrate = 115200,
		.parity = UART_CFG_PARITY_NONE,
		.stop_bits = UART_CFG_STOP_BITS_1,
		.data_bits = UART_CFG_DATA_BITS_8,
		.flow_ctrl = UART_CFG_FLOW_CTRL_NONE,
	};

	ret = uart_configure(uart_dev, &uart_cfg);
	if (ret < 0) {
		printk("Failed to configure UART!\n");
		return;
	}

	// 启用UART接收中断
	ret = uart_irq_callback_set(uart_dev, uart_cb);
	if (ret < 0) {
		printk("Failed to set UART callback!\n");
		return;
	}

	uart_irq_rx_enable(uart_dev);

	// 发送测试数据
	const char *msg = "Hello UART!\n";
	uart_poll_out(uart_dev, msg, strlen(msg));

	while (1) {
		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成 UART 收发实验 □ 掌握 UART 中断配置 □ 理解 UART 子系统架构

---

#### 第 17 天：I2C 总线通信

**学习目标**：掌握 Zephyr I2C 驱动的使用  
**今日任务**：

1. 理解 Zephyr I2C 子系统的架构
    
2. 学习 Zephyr I2C 子系统的使用
    
3. 练习 I2C 设备的探测和通信
    
4. 学习使用 I2C 读取传感器数据
    
5. 练习实现 I2C 驱动的基本操作
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/sys/printk.h>

// 定义I2C设备和传感器地址
#define I2C_DEVICE_NODE DT_ALIAS(i2c0)
static const struct device *i2c_dev = DEVICE_DT_GET(I2C_DEVICE_NODE);
#define SENSOR_ADDR 0x48 // 示例传感器地址

// 读取传感器数据
int read_sensor_data(uint16_t *data)
{
	uint8_t reg = 0x00; // 数据寄存器地址
	uint8_t buf[2];

	if (!device_is_ready(i2c_dev)) {
		printk("I2C device not ready!\n");
		return -1;
	}

	// 写入寄存器地址
	if (i2c_write(i2c_dev, &reg, 1, SENSOR_ADDR) != 0) {
		printk("Failed to write register address!\n");
		return -1;
	}

	// 读取数据
	if (i2c_read(i2c_dev, buf, 2, SENSOR_ADDR) != 0) {
		printk("Failed to read sensor data!\n");
		return -1;
	}

	// 转换数据
	*data = (buf[0] << 8) | buf[1];
	return 0;
}

void main(void)
{
	uint16_t sensor_data;

	if (!device_is_ready(i2c_dev)) {
		printk("I2C device not ready!\n");
		return;
	}

	while (1) {
		if (read_sensor_data(&sensor_data) == 0) {
			printk("Sensor data: %d\n", sensor_data);
		}
		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成 I2C 设备探测 □ 完成传感器数据读取实验 □ 掌握 I2C 子系统的使用

---

#### 第 18 天：SPI 总线通信

**学习目标**：掌握 Zephyr SPI 驱动的使用  
**今日任务**：

1. 理解 Zephyr SPI 子系统的架构
    
2. 学习 Zephyr SPI 子系统的使用
    
3. 练习 SPI 设备的配置和通信
    
4. 学习使用 SPI 控制外设
    
5. 练习实现 SPI 驱动的基本操作
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/spi.h>
#include <zephyr/sys/printk.h>
#include <string.h>

// 定义SPI设备
#define SPI_DEVICE_NODE DT_ALIAS(spi0)
static const struct device *spi_dev = DEVICE_DT_GET(SPI_DEVICE_NODE);

// SPI配置
static const struct spi_config spi_cfg = {
	.frequency = 1000000, // 1MHz
	.operation = SPI_OP_MODE_MASTER | SPI_WORD_SET(8) | SPI_LINES_SINGLE,
	.slave = 0, // 从设备选择线
};

// 读写SPI设备
int spi_transfer(uint8_t *tx_buf, uint8_t *rx_buf, size_t len)
{
	struct spi_buf tx = {
		.buf = tx_buf,
		.len = len,
	};
	struct spi_buf rx = {
		.buf = rx_buf,
		.len = len,
	};
	const struct spi_buf_set tx_bufs = {
		.buffers = &tx,
		.count = 1,
	};
	const struct spi_buf_set rx_bufs = {
		.buffers = &rx,
		.count = 1,
	};

	if (!device_is_ready(spi_dev)) {
		printk("SPI device not ready!\n");
		return -1;
	}

	return spi_transceive(spi_dev, &spi_cfg, &tx_bufs, &rx_bufs);
}

void main(void)
{
	uint8_t tx_buf[] = {0x01, 0x00};
	uint8_t rx_buf[2];

	if (!device_is_ready(spi_dev)) {
		printk("SPI device not ready!\n");
		return;
	}

	while (1) {
		if (spi_transfer(tx_buf, rx_buf, sizeof(tx_buf)) == 0) {
			printk("SPI TX: %02x %02x, RX: %02x %02x\n",
				   tx_buf[0], tx_buf[1], rx_buf[0], rx_buf[1]);
		}
		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成 SPI 设备配置 □ 完成 SPI 通信实验 □ 掌握 SPI 子系统的使用

---

#### 第 19 天：PWM 驱动

**学习目标**：掌握 Zephyr PWM 驱动的使用  
**今日任务**：

1. 理解 Zephyr PWM 子系统的架构
    
2. 学习 Zephyr PWM 子系统的使用
    
3. 练习使用 PWM 控制 LED 亮度
    
4. 学习 PWM 的频率和占空比配置
    
5. 练习实现 PWM 的动态调整
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/pwm.h>
#include <zephyr/sys/printk.h>

// 定义PWM设备和通道
#define PWM_LED_NODE DT_ALIAS(pwm_led0)
static const struct pwm_dt_spec pwm_led = PWM_DT_SPEC_GET(PWM_LED_NODE);

void main(void)
{
	uint32_t period = PWM_MSEC(1); // 1ms周期
	uint32_t pulse_width = 0;
	int step = PWM_USEC(100); // 100us步长

	if (!device_is_ready(pwm_led.dev)) {
		printk("PWM device not ready!\n");
		return;
	}

	while (1) {
		// 设置PWM占空比
		pwm_set_dt(&pwm_led, period, pulse_width);

		// 调整脉冲宽度
		pulse_width += step;
		if (pulse_width >= period || pulse_width == 0) {
			step = -step;
		}

		k_sleep(K_MSEC(100));
	}
}
```

**学习打卡**：□ 完成 PWM 亮度控制实验 □ 掌握 PWM 频率和占空比配置 □ 理解 PWM 子系统架构

---

#### 第 20 天：ADC 驱动

**学习目标**：掌握 Zephyr ADC 驱动的使用  
**今日任务**：

1. 理解 Zephyr ADC 子系统的架构
    
2. 学习 Zephyr ADC 子系统的使用
    
3. 练习使用 ADC 读取模拟信号
    
4. 学习 ADC 的采样精度和通道配置
    
5. 练习实现 ADC 数据的处理
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/adc.h>
#include <zephyr/sys/printk.h>
#include <math.h>

// 定义ADC通道
#define ADC_NODE DT_ALIAS(adc0)
static const struct adc_dt_spec adc_channel = ADC_DT_SPEC_GET(ADC_NODE);

// ADC缓冲区
static uint16_t adc_buf;
static struct adc_sequence sequence = {
	.buffer = &adc_buf,
	.buffer_size = sizeof(adc_buf),
};

void main(void)
{
	int ret;
	float voltage;

	if (!device_is_ready(adc_channel.dev)) {
		printk("ADC device not ready!\n");
		return;
	}

	// 配置ADC通道
	ret = adc_channel_setup_dt(&adc_channel);
	if (ret < 0) {
		printk("Failed to setup ADC channel!\n");
		return;
	}

	// 配置采样序列
	ret = adc_sequence_init_dt(&adc_channel, &sequence);
	if (ret < 0) {
		printk("Failed to init ADC sequence!\n");
		return;
	}

	while (1) {
		// 启动ADC采样
		ret = adc_read_dt(&adc_channel, &sequence);
		if (ret < 0) {
			printk("ADC read failed: %d\n", ret);
			continue;
		}

		// 转换为电压（假设参考电压为3.3V）
		voltage = (float)adc_buf * 3.3f / (1 << adc_channel.resolution);
		printk("ADC value: %d, Voltage: %.2fV\n", adc_buf, voltage);

		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成 ADC 采样实验 □ 掌握 ADC 精度配置 □ 理解 ADC 子系统架构

---

#### 第 21 天：外设综合实验

**学习目标**：综合运用本周学习的外设驱动知识  
**今日任务**：

1. 回顾本周学习的所有外设驱动
    
2. 设计一个综合实验，包含 GPIO、UART、ADC 和 PWM
    
3. 练习调试和优化外设应用
    
4. 学习外设驱动的最佳实践
    
5. 总结外设开发的常见问题和解决方法
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/drivers/uart.h>
#include <zephyr/drivers/adc.h>
#include <zephyr/drivers/pwm.h>
#include <zephyr/sys/printk.h>
#include <string.h>

// 设备定义
#define LED_NODE DT_ALIAS(led0)
#define KEY_NODE DT_ALIAS(sw0)
#define UART_NODE DT_CHOSEN(zephyr_shell_uart)
#define ADC_NODE DT_ALIAS(adc0)
#define PWM_LED_NODE DT_ALIAS(pwm_led0)

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED_NODE, gpios);
static const struct gpio_dt_spec key = GPIO_DT_SPEC_GET(KEY_NODE, gpios);
static const struct device *uart_dev = DEVICE_DT_GET(UART_NODE);
static const struct adc_dt_spec adc_channel = ADC_DT_SPEC_GET(ADC_NODE);
static const struct pwm_dt_spec pwm_led = PWM_DT_SPEC_GET(PWM_LED_NODE);

// ADC变量
static uint16_t adc_buf;
static struct adc_sequence adc_sequence = {
	.buffer = &adc_buf,
	.buffer_size = sizeof(adc_buf),
};

// 按键回调
void key_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	printk("Key pressed!\n");
	gpio_pin_toggle_dt(&led);
}

static struct gpio_callback key_cb_data;

void main(void)
{
	int ret;
	float voltage;
	uint32_t pwm_period = PWM_MSEC(1);
	uint32_t pwm_pulse = 0;

	// 初始化LED
	if (!device_is_ready(led.port)) {
		printk("LED device not ready!\n");
		return;
	}
	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		printk("Failed to configure LED!\n");
		return;
	}

	// 初始化按键
	if (!device_is_ready(key.port)) {
		printk("Key device not ready!\n");
		return;
	}
	ret = gpio_pin_configure_dt(&key, GPIO_INPUT | GPIO_INT_EDGE_TO_ACTIVE);
	if (ret < 0) {
		printk("Failed to configure key!\n");
		return;
	}
	gpio_init_callback(&key_cb_data, key_pressed, BIT(key.pin));
	ret = gpio_add_callback(key.port, &key_cb_data);
	if (ret < 0) {
		printk("Failed to add key callback!\n");
		return;
	}
	ret = gpio_pin_interrupt_configure_dt(&key, GPIO_INT_EDGE_TO_ACTIVE);
	if (ret < 0) {
		printk("Failed to enable key interrupt!\n");
		return;
	}

	// 初始化UART
	if (!device_is_ready(uart_dev)) {
		printk("UART device not ready!\n");
		return;
	}
	const struct uart_config uart_cfg = {
		.baudrate = 115200,
		.parity = UART_CFG_PARITY_NONE,
		.stop_bits = UART_CFG_STOP_BITS_1,
		.data_bits = UART_CFG_DATA_BITS_8,
		.flow_ctrl = UART_CFG_FLOW_CTRL_NONE,
	};
	ret = uart_configure(uart_dev, &uart_cfg);
	if (ret < 0) {
		printk("Failed to configure UART!\n");
		return;
	}

	// 初始化ADC
	if (!device_is_ready(adc_channel.dev)) {
		printk("ADC device not ready!\n");
		return;
	}
	ret = adc_channel_setup_dt(&adc_channel);
	if (ret < 0) {
		printk("Failed to setup ADC channel!\n");
		return;
	}
	ret = adc_sequence_init_dt(&adc_channel, &adc_sequence);
	if (ret < 0) {
		printk("Failed to init ADC sequence!\n");
		return;
	}

	// 初始化PWM
	if (!device_is_ready(pwm_led.dev)) {
		printk("PWM device not ready!\n");
		return;
	}

	// 发送初始化消息
	const char *init_msg = "Peripheral综合实验启动!\n";
	uart_poll_out(uart_dev, init_msg, strlen(init_msg));

	while (1) {
		// 读取ADC
		ret = adc_read_dt(&adc_channel, &adc_sequence);
		if (ret == 0) {
			voltage = (float)adc_buf * 3.3f / (1 << adc_channel.resolution);
			printk("ADC value: %d, Voltage: %.2fV\n", adc_buf, voltage);

			// 根据ADC值调整PWM亮度
			pwm_pulse = (uint32_t)(voltage / 3.3f * pwm_period);
			pwm_set_dt(&pwm_led, pwm_period, pwm_pulse);

			// 通过UART发送数据
			char uart_msg[64];
			snprintf(uart_msg, sizeof(uart_msg), "Voltage: %.2fV, PWM: %d%%\n",
					 voltage, (int)(pwm_pulse * 100 / pwm_period));
			uart_poll_out(uart_dev, uart_msg, strlen(uart_msg));
		}

		k_sleep(K_SECONDS(1));
	}
}
```

**本周总结**：

1. 整理本周学习的外设驱动知识点
    
2. 记录外设开发中遇到的问题和解决方法
    
3. 总结外设驱动开发的最佳实践
    

---

## 第 22-28 天：网络和高级功能周

### 学习目标

掌握 Zephyr 网络子系统和高级功能，能够实现 UDP、TCP、BLE 通信，以及低功耗管理。

---

#### 第 22 天：网络基础和配置

**学习目标**：理解 Zephyr 网络子系统的基本概念  
**今日任务**：

1. 了解 Zephyr 网络子系统的架构
    
2. 学习网络配置的基本方法
    
3. 练习启用网络支持的配置
    
4. 理解网络接口的概念
    
5. 学习网络栈的初始化流程
    

**实践操作**：

```bash

# 启用网络支持的配置
# 在prj.conf中添加以下配置
CONFIG_NETWORKING=y
CONFIG_NET_IPV4=y
CONFIG_NET_IPV6=y
CONFIG_NET_UDP=y
CONFIG_NET_TCP=y
CONFIG_NET_SOCKETS=y

# 构建网络示例
west build -b qemu_x86 samples/net/sockets/echo_server
west build -t run
```

**学习资源**：

- [Zephyr 网络子系统文档](https://docs.zephyrproject.org/latest/networking/index.html)

**学习打卡**：□ 完成网络配置启用 □ 理解网络子系统架构 □ 运行网络示例程序

---

#### 第 23 天：UDP 通信

**学习目标**：掌握 Zephyr UDP 通信的实现  
**今日任务**：

1. 学习 Zephyr UDP 套接字的使用
    
2. 练习实现 UDP 客户端和服务器
    
3. 学习 UDP 数据的收发处理
    
4. 了解 UDP 的特点和使用场景
    
5. 练习调试 UDP 通信
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/net/socket.h>
#include <string.h>

#define UDP_PORT 12345
#define BUF_SIZE 128

void udp_server(void)
{
	int sock;
	struct sockaddr_in server_addr, client_addr;
	socklen_t client_addr_len = sizeof(client_addr);
	char buf[BUF_SIZE];
	int ret;

	// 创建UDP套接字
	sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (sock < 0) {
		printk("Failed to create socket: %d\n", errno);
		return;
	}

	// 配置服务器地址
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(UDP_PORT);
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

	// 绑定地址
	ret = bind(sock, (struct sockaddr *)&server_addr, sizeof(server_addr));
	if (ret < 0) {
		printk("Failed to bind socket: %d\n", errno);
		close(sock);
		return;
	}

	printk("UDP server started on port %d\n", UDP_PORT);

	while (1) {
		// 接收数据
		ret = recvfrom(sock, buf, BUF_SIZE, 0,
					   (struct sockaddr *)&client_addr, &client_addr_len);
		if (ret < 0) {
			printk("Failed to receive data: %d\n", errno);
			continue;
		}

		buf[ret] = '\0';
		printk("Received from %s:%d: %s\n",
			   inet_ntoa(client_addr.sin_addr),
			   ntohs(client_addr.sin_port),
			   buf);

		// 发送响应
		const char *response = "Received your message!";
		ret = sendto(sock, response, strlen(response), 0,
					 (struct sockaddr *)&client_addr, client_addr_len);
		if (ret < 0) {
			printk("Failed to send response: %d\n", errno);
		}
	}
}

void main(void)
{
	k_thread_create(NULL, NULL, K_THREAD_STACK_SIZEOF(4096),
					(k_thread_entry_t)udp_server, NULL, NULL, NULL,
					5, 0, K_NO_WAIT);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成 UDP 服务器实现 □ 掌握 UDP 套接字使用 □ 调试 UDP 通信

---

#### 第 24 天：TCP 通信

**学习目标**：掌握 Zephyr TCP 通信的实现  
**今日任务**：

1. 学习 Zephyr TCP 套接字的使用
    
2. 练习实现 TCP 服务器和客户端
    
3. 学习 TCP 连接的建立和关闭
    
4. 了解 TCP 的特点和使用场景
    
5. 练习调试 TCP 通信
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/net/socket.h>
#include <string.h>

#define TCP_PORT 12345
#define BUF_SIZE 128

void tcp_server(void)
{
	int server_sock, client_sock;
	struct sockaddr_in server_addr, client_addr;
	socklen_t client_addr_len = sizeof(client_addr);
	char buf[BUF_SIZE];
	int ret;

	// 创建TCP套接字
	server_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (server_sock < 0) {
		printk("Failed to create socket: %d\n", errno);
		return;
	}

	// 配置服务器地址
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(TCP_PORT);
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

	// 绑定地址
	ret = bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr));
	if (ret < 0) {
		printk("Failed to bind socket: %d\n", errno);
		close(server_sock);
		return;
	}

	// 监听连接
	ret = listen(server_sock, 5);
	if (ret < 0) {
		printk("Failed to listen: %d\n", errno);
		close(server_sock);
		return;
	}

	printk("TCP server started on port %d\n", TCP_PORT);

	while (1) {
		// 接受客户端连接
		client_sock = accept(server_sock, (struct sockaddr *)&client_addr, &client_addr_len);
		if (client_sock < 0) {
			printk("Failed to accept connection: %d\n", errno);
			continue;
		}

		printk("Client connected: %s:%d\n",
			   inet_ntoa(client_addr.sin_addr),
			   ntohs(client_addr.sin_port));

		// 接收数据
		ret = recv(client_sock, buf, BUF_SIZE, 0);
		if (ret < 0) {
			printk("Failed to receive data: %d\n", errno);
			close(client_sock);
			continue;
		} else if (ret == 0) {
			printk("Client disconnected\n");
			close(client_sock);
			continue;
		}

		buf[ret] = '\0';
		printk("Received from client: %s\n", buf);

		// 发送响应
		const char *response = "Received your message!";
		ret = send(client_sock, response, strlen(response), 0);
		if (ret < 0) {
			printk("Failed to send response: %d\n", errno);
		}

		close(client_sock);
	}
}

void main(void)
{
	k_thread_create(NULL, NULL, K_THREAD_STACK_SIZEOF(4096),
					(k_thread_entry_t)tcp_server, NULL, NULL, NULL,
					5, 0, K_NO_WAIT);

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成 TCP 服务器实现 □ 掌握 TCP 套接字使用 □ 调试 TCP 通信

---

#### 第 25 天：BLE 功能

**学习目标**：掌握 Zephyr BLE 功能的使用  
**今日任务**：

1. 理解 Zephyr BLE 子系统的架构
    
2. 学习 BLE 服务和特征的定义
    
3. 练习实现 BLE 外设
    
4. 学习 BLE 数据的收发
    
5. 了解 BLE 的低功耗特性
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/hci.h>
#include <zephyr/bluetooth/conn.h>
#include <zephyr/bluetooth/uuid.h>
#include <zephyr/bluetooth/gatt.h>

// 定义服务和特征UUID
#define BT_UUID_MY_SERVICE_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef0)
#define BT_UUID_MY_CHAR_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef1)

static struct bt_uuid_128 my_service_uuid = BT_UUID_INIT_128(BT_UUID_MY_SERVICE_VAL);
static struct bt_uuid_128 my_char_uuid = BT_UUID_INIT_128(BT_UUID_MY_CHAR_VAL);

// 特征值
static uint8_t my_char_value[] = "Hello BLE!";
static ssize_t read_my_char(struct bt_conn *conn, const struct bt_gatt_attr *attr,
							void *buf, uint16_t len, uint16_t offset)
{
	const char *value = attr->user_data;
	return bt_gatt_attr_read(conn, attr, buf, len, offset, value, strlen(value));
}

static ssize_t write_my_char(struct bt_conn *conn, const struct bt_gatt_attr *attr,
							 const void *buf, uint16_t len, uint16_t offset, uint8_t flags)
{
	uint8_t *value = attr->user_data;

	if (offset + len > sizeof(my_char_value) - 1) {
		return BT_GATT_ERR(BT_ATT_ERR_INVALID_OFFSET);
	}

	memcpy(value + offset, buf, len);
	value[offset + len] = '\0';

	printk("Received write: %s\n", value);
	return len;
}

// GATT服务定义
BT_GATT_SERVICE_DEFINE(my_service,
	BT_GATT_PRIMARY_SERVICE(&my_service_uuid),
	BT_GATT_CHARACTERISTIC(&my_char_uuid.uuid,
			       BT_GATT_CHRC_READ | BT_GATT_CHRC_WRITE,
			       BT_GATT_PERM_READ | BT_GATT_PERM_WRITE,
			       read_my_char, write_my_char, my_char_value),
);

// BLE连接回调
static void connected(struct bt_conn *conn, uint8_t err)
{
	if (err) {
		printk("Connection failed (err %u)\n", err);
		return;
	}

	printk("Connected\n");
}

static void disconnected(struct bt_conn *conn, uint8_t reason)
{
	printk("Disconnected (reason %u)\n", reason);
}

BT_CONN_CB_DEFINE(conn_callbacks) = {
	.connected = connected,
	.disconnected = disconnected,
};

// BLE就绪回调
static void bt_ready(int err)
{
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}

	printk("Bluetooth initialized\n");

	// 开始广播
	struct bt_le_adv_param adv_param = BT_LE_ADV_PARAM_INIT(
		BT_LE_ADV_OPT_CONNECTABLE | BT_LE_ADV_OPT_USE_NAME,
		BT_GAP_ADV_FAST_INT_MIN_2,
		BT_GAP_ADV_FAST_INT_MAX_2,
		NULL);

	struct bt_le_adv_data adv_data = BT_LE_ADV_DATA_INIT(
		BT_LE_ADV_DATA_NAME | BT_LE_ADV_DATA_SVC_DATA,
		NULL, 0);

	err = bt_le_adv_start(&adv_param, &adv_data, NULL, 0);
	if (err) {
		printk("Advertising failed to start (err %d)\n", err);
		return;
	}

	printk("Advertising started\n");
}

void main(void)
{
	int err;

	err = bt_enable(bt_ready);
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}

	while (1) {
		k_sleep(K_FOREVER);
	}
}
```

**学习打卡**：□ 完成 BLE 外设实现 □ 掌握 BLE 服务和特征定义 □ 调试 BLE 通信

---

#### 第 26 天：低功耗管理

**学习目标**：掌握 Zephyr 低功耗管理的方法  
**今日任务**：

1. 理解 Zephyr 的电源管理架构
    
2. 学习低功耗模式的配置和使用
    
3. 练习使用电源管理 API
    
4. 了解低功耗优化的技巧
    
5. 练习测量和优化系统功耗
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/pm/pm.h>
#include <zephyr/pm/device.h>

// 低功耗回调
static void pm_state_exit_post_ops(struct pm_state_info info)
{
	printk("Exited low power state: %d\n", info.state);
}

PM_STATE_POST_EXIT_OPS_DEFINE(pm_state_exit_ops) = {
	.state = PM_STATE_SUSPEND_TO_IDLE,
	.post_exit = pm_state_exit_post_ops,
};

void main(void)
{
	printk("Low power management example\n");

	// 启用电源管理
	pm_enable();

	while (1) {
		printk("Entering low power state...\n");

		// 进入低功耗模式
		pm_system_suspend(NULL);

		printk("Woke up from low power state\n");
		k_sleep(K_SECONDS(5));
	}
}
```

**学习打卡**：□ 完成低功耗模式配置 □ 掌握电源管理 API 使用 □ 了解低功耗优化技巧

---

#### 第 27 天：高级功能综合实验

**学习目标**：综合运用本周学习的网络和高级功能  
**今日任务**：

1. 回顾本周学习的所有网络和高级功能
    
2. 设计一个综合实验，包含 BLE 和网络通信
    
3. 练习调试和优化复杂应用
    
4. 学习系统集成的最佳实践
    
5. 总结高级功能的使用技巧
    

**实践操作**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/gatt.h>
#include <zephyr/net/socket.h>
#include <string.h>

// BLE定义
#define BT_UUID_ENV_SERVICE_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef0)
#define BT_UUID_TEMP_CHAR_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef1)
#define BT_UUID_HUMIDITY_CHAR_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef2)

static struct bt_uuid_128 env_service_uuid = BT_UUID_INIT_128(BT_UUID_ENV_SERVICE_VAL);
static struct bt_uuid_128 temp_char_uuid = BT_UUID_INIT_128(BT_UUID_TEMP_CHAR_VAL);
static struct bt_uuid_128 humidity_char_uuid = BT_UUID_INIT_128(BT_UUID_HUMIDITY_CHAR_VAL);

static float temperature = 25.0f;
static float humidity = 50.0f;

// 网络定义
#define MQTT_BROKER "192.168.1.100"
#define MQTT_PORT 1883
#define MQTT_TOPIC "env/data"

// BLE特征读取回调
static ssize_t read_temp(struct bt_conn *conn, const struct bt_gatt_attr *attr,
						 void *buf, uint16_t len, uint16_t offset)
{
	char temp_str[16];
	snprintf(temp_str, sizeof(temp_str), "%.1f", temperature);
	return bt_gatt_attr_read(conn, attr, buf, len, offset, temp_str, strlen(temp_str));
}

static ssize_t read_humidity(struct bt_conn *conn, const struct bt_gatt_attr *attr,
							 void *buf, uint16_t len, uint16_t offset)
{
	char hum_str[16];
	snprintf(hum_str, sizeof(hum_str), "%.1f", humidity);
	return bt_gatt_attr_read(conn, attr, buf, len, offset, hum_str, strlen(hum_str));
}

// GATT服务定义
BT_GATT_SERVICE_DEFINE(env_service,
	BT_GATT_PRIMARY_SERVICE(&env_service_uuid),
	BT_GATT_CHARACTERISTIC(&temp_char_uuid.uuid,
			       BT_GATT_CHRC_READ,
			       BT_GATT_PERM_READ,
			       read_temp, NULL, NULL),
	BT_GATT_CHARACTERISTIC(&humidity_char_uuid.uuid,
			       BT_GATT_CHRC_READ,
			       BT_GATT_PERM_READ,
			       read_humidity, NULL, NULL),
);

// BLE连接回调
static void connected(struct bt_conn *conn, uint8_t err)
{
	if (err) {
		printk("Connection failed (err %u)\n", err);
		return;
	}
	printk("Connected\n");
}

static void disconnected(struct bt_conn *conn, uint8_t reason)
{
	printk("Disconnected (reason %u)\n", reason);
}

BT_CONN_CB_DEFINE(conn_callbacks) = {
	.connected = connected,
	.disconnected = disconnected,
};

// BLE就绪回调
static void bt_ready(int err)
{
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}
	printk("Bluetooth initialized\n");

	// 开始广播
	struct bt_le_adv_param adv_param = BT_LE_ADV_PARAM_INIT(
		BT_LE_ADV_OPT_CONNECTABLE | BT_LE_ADV_OPT_USE_NAME,
		BT_GAP_ADV_FAST_INT_MIN_2,
		BT_GAP_ADV_FAST_INT_MAX_2,
		NULL);

	struct bt_le_adv_data adv_data = BT_LE_ADV_DATA_INIT(
		BT_LE_ADV_DATA_NAME | BT_LE_ADV_DATA_SVC_DATA,
		NULL, 0);

	err = bt_le_adv_start(&adv_param, &adv_data, NULL, 0);
	if (err) {
		printk("Advertising failed to start (err %d)\n", err);
		return;
	}
	printk("Advertising started\n");
}

// MQTT发送任务
void mqtt_send_task(void)
{
	int sock;
	struct sockaddr_in broker_addr;
	char mqtt_msg[64];
	int ret;

	while (1) {
		// 创建TCP套接字
		sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if (sock < 0) {
			printk("Failed to create socket: %d\n", errno);
			k_sleep(K_SECONDS(5));
			continue;
		}

		// 配置 broker 地址
		memset(&broker_addr, 0, sizeof(broker_addr));
		broker_addr.sin_family = AF_INET;
		broker_addr.sin_port = htons(MQTT_PORT);
		if (inet_pton(AF_INET, MQTT_BROKER, &broker_addr.sin_addr) <= 0) {
			printk("Invalid broker address\n");
			close(sock);
			k_sleep(K_SECONDS(5));
			continue;
		}

		// 连接到 broker
		ret = connect(sock, (struct sockaddr *)&broker_addr, sizeof(broker_addr));
		if (ret < 0) {
			printk("Failed to connect to broker: %d\n", errno);
			close(sock);
			k_sleep(K_SECONDS(5));
			continue;
		}

		// 构建MQTT消息
		snprintf(mqtt_msg, sizeof(mqtt_msg),
				 "{\\"temperature\\": %.1f, \\"humidity\\": %.1f}",
				 temperature, humidity);

		// 发送MQTT消息（简化版，实际需要MQTT协议处理）
		printk("Sending MQTT message: %s\n", mqtt_msg);
		ret = send(sock, mqtt_msg, strlen(mqtt_msg), 0);
		if (ret < 0) {
			printk("Failed to send message: %d\n", errno);
		}

		close(sock);
		k_sleep(K_SECONDS(10));
	}
}

void main(void)
{
	int err;

	// 初始化BLE
	err = bt_enable(bt_ready);
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}

	// 创建MQTT发送线程
	k_thread_create(NULL, NULL, K_THREAD_STACK_SIZEOF(4096),
					(k_thread_entry_t)mqtt_send_task, NULL, NULL, NULL,
					5, 0, K_NO_WAIT);

	while (1) {
		// 模拟传感器数据变化
		temperature += 0.1f;
		if (temperature > 30.0f) {
			temperature = 25.0f;
		}
		humidity += 0.5f;
		if (humidity > 60.0f) {
			humidity = 50.0f;
		}

		k_sleep(K_SECONDS(1));
	}
}
```

**学习打卡**：□ 完成 BLE 和网络综合实验 □ 掌握系统集成方法 □ 调试复杂应用

---

#### 第 28 天：高级功能总结

**学习目标**：总结本周学习的高级功能  
**今日任务**：

1. 回顾本周学习的所有网络和高级功能
    
2. 整理学习过程中遇到的问题和解决方法
    
3. 总结网络和 BLE 开发的最佳实践
    
4. 学习 Zephyr 的其他高级功能（如 OTA、安全功能）
    
5. 制定后续的高级功能学习计划
    

**本周总结**：

1. 整理网络和 BLE 开发的核心知识点
    
2. 记录高级功能开发中遇到的问题和解决方法
    
3. 总结系统集成和低功耗优化的最佳实践
    

---

## 第 29-30 天：综合项目周

### 学习目标

完成一个完整的 Zephyr 应用项目，综合运用前四周学习的所有知识，能够独立设计、实现和调试 Zephyr 应用。

---

#### 第 29 天：项目需求分析和设计

**学习目标**：完成一个完整的 Zephyr 应用项目的需求分析和设计  
**今日任务**：

1. 确定项目需求和功能规格
    
2. 设计系统架构和模块划分
    
3. 选择合适的硬件平台和外设
    
4. 制定项目计划和时间表
    
5. 准备开发环境和工具
    

**项目示例：智能温湿度监测节点**  
**项目需求**：

- 读取温湿度传感器数据
    
- 通过 BLE 广播传感器数据
    
- 通过 MQTT 将数据上传到物联网平台
    
- 支持按键交互（切换工作模式）
    
- 低功耗运行
    
- LED 状态指示
    

**系统架构**：

- 传感器层：温湿度传感器（通过 I2C 连接）
    
- 处理层：数据处理和协议转换
    
- 通信层：BLE 广播和 MQTT 通信
    
- 控制层：按键交互和 LED 状态指示
    

**硬件选择**：

- 开发板：nRF52840 DK（支持 BLE 和网络）
    
- 传感器：SHT30 温湿度传感器（I2C 接口）
    

**项目计划**：

1. 第 1 天：完成硬件连接和环境准备
    
2. 第 2 天：实现传感器数据读取
    
3. 第 3 天：实现 BLE 广播功能
    
4. 第 4 天：实现 MQTT 通信功能
    
5. 第 5 天：实现按键交互和 LED 指示
    
6. 第 6 天：调试和优化系统
    
7. 第 7 天：系统测试和总结
    

---

#### 第 30 天：项目实现和总结

**学习目标**：完成综合项目的实现并总结学习成果  
**今日任务**：

1. 实现项目的所有功能模块
    
2. 调试和优化项目代码
    
3. 进行系统测试和验证
    
4. 总结 30 天学习的收获和经验
    
5. 制定后续学习计划
    

**项目实现代码**：

```c

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/hci.h>
#include <zephyr/net/socket.h>
#include <string.h>
#include <stdio.h>

// 硬件定义
#define I2C_DEVICE_NODE DT_ALIAS(i2c0)
#define SHT30_ADDR 0x44
#define LED_NODE DT_ALIAS(led0)
#define KEY_NODE DT_ALIAS(sw0)

// BLE定义
#define BT_UUID_ENV_SERVICE_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef0)
#define BT_UUID_TEMP_CHAR_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef1)
#define BT_UUID_HUMIDITY_CHAR_VAL BT_UUID_128_ENCODE(0x12345678, 0x1234, 0x5678, 0x1234, 0x56789abcdef2)

// 网络定义
#define MQTT_BROKER "192.168.1.100"
#define MQTT_PORT 1883
#define MQTT_TOPIC "env/data"

// 全局变量
static const struct device *i2c_dev = DEVICE_DT_GET(I2C_DEVICE_NODE);
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED_NODE, gpios);
static const struct gpio_dt_spec key = GPIO_DT_SPEC_GET(KEY_NODE, gpios);

static struct bt_uuid_128 env_service_uuid = BT_UUID_INIT_128(BT_UUID_ENV_SERVICE_VAL);
static struct bt_uuid_128 temp_char_uuid = BT_UUID_INIT_128(BT_UUID_TEMP_CHAR_VAL);
static struct bt_uuid_128 humidity_char_uuid = BT_UUID_INIT_128(BT_UUID_HUMIDITY_CHAR_VAL);

static float temperature = 0.0f;
static float humidity = 0.0f;
static bool mqtt_enabled = true;

// 按键回调
static struct gpio_callback key_cb_data;

void key_pressed(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	mqtt_enabled = !mqtt_enabled;
	printk("MQTT mode %s\n", mqtt_enabled ? "enabled" : "disabled");
	gpio_pin_toggle_dt(&led);
}

// 读取SHT30数据
int read_sht30(float *temp, float *hum)
{
	uint8_t cmd[] = {0x2C, 0x06};
	uint8_t data[6];
	int ret;

	if (!device_is_ready(i2c_dev)) {
		printk("I2C device not ready!\n");
		return -1;
	}

	// 发送测量命令
	ret = i2c_write(i2c_dev, cmd, sizeof(cmd), SHT30_ADDR);
	if (ret < 0) {
		printk("Failed to send command: %d\n", ret);
		return -1;
	}

	k_sleep(K_MSEC(100));

	// 读取数据
	ret = i2c_read(i2c_dev, data, sizeof(data), SHT30_ADDR);
	if (ret < 0) {
		printk("Failed to read data: %d\n", ret);
		return -1;
	}

	// 计算温度和湿度
	uint16_t temp_raw = (data[0] << 8) | data[1];
	uint16_t hum_raw = (data[3] << 8) | data[4];

	*temp = -45.0f + 175.0f * (float)temp_raw / 65535.0f;
	*hum = 100.0f * (float)hum_raw / 65535.0f;

	return 0;
}

// BLE特征读取回调
static ssize_t read_temp(struct bt_conn *conn, const struct bt_gatt_attr *attr,
						 void *buf, uint16_t len, uint16_t offset)
{
	char temp_str[16];
	snprintf(temp_str, sizeof(temp_str), "%.1f", temperature);
	return bt_gatt_attr_read(conn, attr, buf, len, offset, temp_str, strlen(temp_str));
}

static ssize_t read_humidity(struct bt_conn *conn, const struct bt_gatt_attr *attr,
							 void *buf, uint16_t len, uint16_t offset)
{
	char hum_str[16];
	snprintf(hum_str, sizeof(hum_str), "%.1f", humidity);
	return bt_gatt_attr_read(conn, attr, buf, len, offset, hum_str, strlen(hum_str));
}

// GATT服务定义
BT_GATT_SERVICE_DEFINE(env_service,
	BT_GATT_PRIMARY_SERVICE(&env_service_uuid),
	BT_GATT_CHARACTERISTIC(&temp_char_uuid.uuid,
			       BT_GATT_CHRC_READ,
			       BT_GATT_PERM_READ,
			       read_temp, NULL, NULL),
	BT_GATT_CHARACTERISTIC(&humidity_char_uuid.uuid,
			       BT_GATT_CHRC_READ,
			       BT_GATT_PERM_READ,
			       read_humidity, NULL, NULL),
);

// BLE连接回调
static void connected(struct bt_conn *conn, uint8_t err)
{
	if (err) {
		printk("Connection failed (err %u)\n", err);
		return;
	}
	printk("Connected\n");
	gpio_pin_set_dt(&led, 1);
}

static void disconnected(struct bt_conn *conn, uint8_t reason)
{
	printk("Disconnected (reason %u)\n", reason);
	gpio_pin_set_dt(&led, 0);
}

BT_CONN_CB_DEFINE(conn_callbacks) = {
	.connected = connected,
	.disconnected = disconnected,
};

// BLE就绪回调
static void bt_ready(int err)
{
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}
	printk("Bluetooth initialized\n");

	// 开始广播
	struct bt_le_adv_param adv_param = BT_LE_ADV_PARAM_INIT(
		BT_LE_ADV_OPT_CONNECTABLE | BT_LE_ADV_OPT_USE_NAME,
		BT_GAP_ADV_FAST_INT_MIN_2,
		BT_GAP_ADV_FAST_INT_MAX_2,
		NULL);

	struct bt_le_adv_data adv_data = BT_LE_ADV_DATA_INIT(
		BT_LE_ADV_DATA_NAME | BT_LE_ADV_DATA_SVC_DATA,
		NULL, 0);

	err = bt_le_adv_start(&adv_param, &adv_data, NULL, 0);
	if (err) {
		printk("Advertising failed to start (err %d)\n", err);
		return;
	}
	printk("Advertising started\n");
}

// MQTT发送任务
void mqtt_send_task(void)
{
	int sock;
	struct sockaddr_in broker_addr;
	char mqtt_msg[64];
	int ret;

	while (1) {
		if (!mqtt_enabled) {
			k_sleep(K_SECONDS(1));
			continue;
		}

		// 创建TCP套接字
		sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if (sock < 0) {
			printk("Failed to create socket: %d\n", errno);
			k_sleep(K_SECONDS(5));
			continue;
		}

		// 配置 broker 地址
		memset(&broker_addr, 0, sizeof(broker_addr));
		broker_addr.sin_family = AF_INET;
		broker_addr.sin_port = htons(MQTT_PORT);
		if (inet_pton(AF_INET, MQTT_BROKER, &broker_addr.sin_addr) <= 0) {
			printk("Invalid broker address\n");
			close(sock);
			k_sleep(K_SECONDS(5));
			continue;
		}

		// 连接到 broker
		ret = connect(sock, (struct sockaddr *)&broker_addr, sizeof(broker_addr));
		if (ret < 0) {
			printk("Failed to connect to broker: %d\n", errno);
			close(sock);
			k_sleep(K_SECONDS(5));
			continue;
		}

		// 构建MQTT消息
		snprintf(mqtt_msg, sizeof(mqtt_msg),
				 "{\\"temperature\\": %.1f, \\"humidity\\": %.1f}",
				 temperature, humidity);

		// 发送MQTT消息（简化版，实际需要MQTT协议处理）
		printk("Sending MQTT message: %s\n", mqtt_msg);
		ret = send(sock, mqtt_msg, strlen(mqtt_msg), 0);
		if (ret < 0) {
			printk("Failed to send message: %d\n", errno);
		}

		close(sock);
		k_sleep(K_SECONDS(10));
	}
}

void main(void)
{
	int err;

	// 初始化LED
	if (!device_is_ready(led.port)) {
		printk("LED device not ready!\n");
		return;
	}
	err = gpio_pin_configure_dt(&led, GPIO_OUTPUT_INACTIVE);
	if (err < 0) {
		printk("Failed to configure LED!\n");
		return;
	}

	// 初始化按键
	if (!device_is_ready(key.port)) {
		printk("Key device not ready!\n");
		return;
	}
	err = gpio_pin_configure_dt(&key, GPIO_INPUT | GPIO_INT_EDGE_TO_ACTIVE);
	if (err < 0) {
		printk("Failed to configure key!\n");
		return;
	}
	gpio_init_callback(&key_cb_data, key_pressed, BIT(key.pin));
	err = gpio_add_callback(key.port, &key_cb_data);
	if (err < 0) {
		printk("Failed to add key callback!\n");
		return;
	}
	err = gpio_pin_interrupt_configure_dt(&key, GPIO_INT_EDGE_TO_ACTIVE);
	if (err < 0) {
		printk("Failed to enable key interrupt!\n");
		return;
	}

	// 初始化BLE
	err = bt_enable(bt_ready);
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}

	// 创建MQTT发送线程
	k_thread_create(NULL, NULL, K_THREAD_STACK_SIZEOF(4096),
					(k_thread_entry_t)mqtt_send_task, NULL, NULL, NULL,
					5, 0, K_NO_WAIT);

	while (1) {
		// 读取传感器数据
		if (read_sht30(&temperature, &humidity) == 0) {
			printk("Temperature: %.1f°C, Humidity: %.1f%%\n", temperature, humidity);
		} else {
			printk("Failed to read sensor data\n");
		}

		k_sleep(K_SECONDS(1));
	}
}
```

**项目测试步骤**：

1. 硬件连接：将 SHT30 传感器连接到开发板的 I2C 接口
    
2. 烧录程序：将代码烧录到开发板
    
3. BLE 测试：使用手机 BLE 扫描工具连接开发板，读取温湿度数据
    
4. 网络测试：确保开发板连接到网络，查看 MQTT broker 是否收到数据
    
5. 按键测试：按下按键，切换 MQTT 模式，查看 LED 状态变化
    
6. 低功耗测试：测量系统在不同模式下的功耗
    

**30 天学习总结**：

1. 掌握了 Zephyr RTOS 的核心概念和架构
    
2. 熟练使用 west 构建系统和设备树
    
3. 掌握了线程管理、同步机制和内核对象的使用
    
4. 学会了开发各类外设驱动（GPIO、UART、I2C、SPI、PWM、ADC）
    
5. 掌握了网络通信和 BLE 开发
    
6. 了解了低功耗优化和系统集成的方法
    

**后续学习建议**：

1. 深入学习 Zephyr 的设备驱动开发，编写自定义驱动
    
2. 研究 Zephyr 的安全功能和加密机制
    
3. 学习 Zephyr 的 OTA 更新机制
    
4. 参与 Zephyr 社区贡献，提交代码和 bug 报告
    
5. 开发实际的物联网产品项目，将学习成果应用到实践中
    

---

## 故障排除指南

### 常见 west 工具问题

1. **west: command not found**
    
    - 解决方法：检查 Zephyr 环境变量是否正确设置，重新运行 [zephyr-env.sh](zephyr-env.sh) 脚本
2. **west update 失败**
    
    - 解决方法：检查网络连接，或者使用代理进行更新，也可以手动克隆仓库
3. **west build 失败，提示找不到设备**
    
    - 解决方法：检查开发板名称是否正确，使用`west boards`查看支持的开发板

### 常见构建问题

1. **CMake 错误：Could not find Zephyr**
    
    - 解决方法：检查 ZEPHYR_BASE 环境变量是否正确设置
2. **编译错误：undefined reference to xxx**
    
    - 解决方法：检查 prj.conf 中是否启用了相关的配置项，或者是否包含了正确的头文件
3. **链接错误：multiple definition of xxx**
    
    - 解决方法：检查代码中是否有重复的函数定义，或者是否链接了重复的库

### 常见仿真问题

1. **QEMU 运行无输出**
    
    - 解决方法：检查串口配置是否正确，或者使用`minicom`工具查看输出
2. **QEMU 崩溃**
    
    - 解决方法：检查开发板配置是否正确，或者降低 QEMU 的仿真参数

### 常见硬件问题

1. **开发板无法识别**
    
    - 解决方法：检查 USB 连接是否正常，安装正确的驱动程序
2. **外设无法通信**
    
    - 解决方法：检查硬件连接是否正确，检查设备树配置是否正确
3. **按键或 LED 无响应**
    
    - 解决方法：检查 GPIO 配置是否正确，检查硬件连接是否正确

---

## 学习打卡模板

### 每日学习打卡

|日期|学习内容|完成情况|遇到的问题|解决方法|
|---|---|---|---|---|
|第 1 天|Zephyr 生态系统了解|□ 完成|无|-|
|第 2 天|项目结构和构建系统|□ 完成|west update 失败|使用代理更新|
|...|...|...|...|...|

### 每周学习总结

## |周次|学习内容|掌握程度|未掌握的内容|下周学习重点| |---|---|---|---|---| |第 1 周|基础入门|80%|设备树覆盖的高级使用|深入学习设备树| |第 2 周|内核深入|75%|优先级继承的细节|练习复杂的线程同步| |...|...|...|...|...|

## 学习资源和工具推荐

### 官方文档

- [Zephyr 官方文档](https://docs.zephyrproject.org/)
    
- [Zephyr API 参考](https://docs.zephyrproject.org/latest/reference/index.html)
    
- [Zephyr GitHub 仓库](https://github.com/zephyrproject-rtos/zephyr)
    

### 学习资源

- [Linux Foundation Zephyr RTOS Programming 课程](https://training.linuxfoundation.org/training/zephyr-rtos-programming/)
    
- [Zephyr RTOS Tutorial for Beginners](https://www.youtube.com/playlist?list=PLBv09BD7ez_5S3bZ8gQw9vqQpYHdE8t0)
    
- [Zephyr RTOS 实战指南](https://book.douban.com/subject/35574768/)
    

### 开发工具

- IDE：VS Code + Zephyr Extension
    
- 调试工具：OpenOCD、GDB
    
- 仿真工具：QEMU
    
- 网络工具：Wireshark、Mosquitto MQTT Broker
    
- 硬件工具：逻辑分析仪、示波器
    

### 硬件推荐

- 入门级：BBC micro:bit v2（£15 左右）
    
- 进阶级：nRF52840 DK（$49）
    
- 经济级：ESP32-C3 开发板（¥20-50）
    
- 专业级：STM32F4Discovery（$19.95）
    

---

## 最佳实践

1. **遵循 Zephyr 的编码规范**：使用 Zephyr 的编码风格，保持代码的可读性和一致性
    
2. **充分利用官方文档**：Zephyr 的官方文档非常详细，遇到问题首先查阅官方文档
    
3. **定期更新 Zephyr 版本**：Zephyr 更新频繁，定期更新可以获得最新的功能和 bug 修复
    
4. **重视代码质量和测试**：编写单元测试，确保代码的稳定性和可靠性
    
5. **关注安全性和低功耗优化**：在物联网应用中，安全性和低功耗是非常重要的考虑因素
    
6. **参与社区贡献**：加入 Zephyr 社区，与其他开发者交流经验，提交代码和 bug 报告
    

希望这份 30 天 Zephyr 工程师训练计划能够帮助您快速成长为一名优秀的 Zephyr 开发工程师。祝您学习顺利！

> （注：文档部分内容可能由 AI 生成）