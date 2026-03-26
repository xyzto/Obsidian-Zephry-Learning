# k_work

> 关联概念：[[k_workqueue]] [[k_delayed_work]]  
> 来源问题：中断/高优先级上下文不能阻塞、不能长时间占用

## 本质
k_work 是 Zephyr 中最基础的“延迟/异步执行”单元，本质是一个带有回调函数的待执行项（struct k_work），必须提交到一个 workqueue 才能被执行。
## 解决什么问题
- 避免在 ISR 或高优先级线程中执行耗时操作（阻塞关键路径）
- 提供从任意上下文（包括 ISR）安全地将任务推迟到线程上下文执行的机制
- 实现“bottom half”风格的延迟处理（类似 Linux softirq/tasklet）
## 核心机制
- struct k_work 包含 handler 函数指针和链表节点
- 提交 → 插入目标 workqueue 的待执行链表尾部（FIFO）
- workqueue 是一个专用线程，循环从链表取 k_work 并调用其 handler
- 同一个 k_work 在 handler 执行期间不允许重复提交（返回 -EBUSY）
- 系统默认提供全局 workqueue：k_sys_work_q（优先级通常 K_PRIO_COOP(1)）
## 区别
- 裸机：通常自己写环形缓冲 + 后台线程/主循环轮询，或直接在 ISR 里做完（风险栈溢出/错过中断）
- Zephyr：统一封装提交 → 队列 → 专用线程模型，线程安全、优先级可控、可多个 workqueue
## 在 Zephyr 里怎么用
1. 定义：`K_WORK_DEFINE(name, handler)` 或 `K_WORK_INITIALIZER(name, handler)`
2. 提交：`k_work_submit(&name)`（默认提交到 k_sys_work_q）  
   或 `k_work_submit_to_queue(queue, &name)`
3. 取消：`k_work_cancel(&name)`（仅移除未开始执行的）
## 产生的问题
→ [[k_work handler 阻塞系统]]  
→ [[k_work 与 k_delayed_work 区别]]
