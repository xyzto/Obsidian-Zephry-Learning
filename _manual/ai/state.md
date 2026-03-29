# State — 仓库状态文件

> 用途：每次对话结束时无条件更新。新对话开始时第一件事就读这个文件。
> 替代原来的 session-log.md 和 handoff.md，统一管理所有状态。

---

## 最后更新：2026-03-29

---

## 当前进度

### QEMU 实验
- ✅ 第一层全部完成（10/10）：01 线程基础、02 信号量、03 Mutex、04 消息队列、05 定时器、06 工作队列、07 事件标志、08 内存池、09 栈溢出检测、10 调度器综合
- ✅ 第二层部分完成（4/6）：11 UART 基础、12 UART 中断、13 GPIO 模拟、14 驱动模型阅读
- ⏭ **下一个：15 设备树覆盖**
- 📁 实验记录：`02-Projects/QEMU/lab/`

### F103ZE
- 暂时搁置，等 QEMU 全部完成后推进

---

## 最近操作

### 2026-03-29 — Vault 系统性优化（结构解耦重构）

**内容越界修复：**
- `05-Questions/` 生产者-消费者三篇文章（越界 Concept 级内容）→ 合并提炼为 `01-Concepts/MessageQueue.md`，原三篇删除
- `04-Resources/Zephyr-STM32F407工程骨架.md`（越界项目模板）→ 迁移至 `02-Projects/F103ZE/templates/`，原文件删除

**空壳文件填充：**
- `01-Concepts/Mutex.md` → 填充完整内容（所有权、优先级继承、API、坑）
- `01-Concepts/Priority_Inversion.md` → 填充完整内容（三线程翻转场景、Zephyr 解法）
- `01-Concepts/ThreadPriority.md` → 填充完整内容（数值规则、抢占/协作、时间片）

**Questions 状态关闭：**
- `05-Questions/优先级翻转如何发生？.md` → 填写结论，标记 #已验证
- `05-Questions/什么时候该用信号量而不是互斥锁？.md` → 填写结论，标记 #已验证

**系统提示词升级：**
- `_manual/ai/study-prompt.md` → 阶段5新增笔记分类前置声明规则（type: concept/question/inbox）
- `_manual/ai/vault-prompt.md` → 启动流程新增三条健康检查（Inbox老化/Questions晋升/README同步）；新增笔记分类路由规则；新增 04-Resources 排斥规则；新增 Concept 新建后自动同步 README 规则

**README 全面更新：**
- Concepts 列表从 12 个同步至 21 个（补 MessageQueue、Mutex、Priority_Inversion、ThreadPriority、GDB、k_work、k_event、Zephyr子系统、DEVICE_DT_DEFINE）
- 04-Resources 说明补充"不放正文内容"约束
- 05-Questions 说明更新为"有待验证的结论"边界定义
- 进度状态更新至当前实际进度

---

## 下一步

- 继续 QEMU 实验 15 设备树覆盖
- 执行"刷新 study-context"，将 study-prompt.md 的修改同步至 study-context.md

---

## 待办

- [ ] 刷新 study-context.md（study-prompt.md 已更新，需同步合并）
- [ ] 补全 `01-Concepts/GDB.md` 内容（目前为标准格式空壳，待实验后填充）
- [ ] 补全 `01-Concepts/k_event.md` 内容（待 Exp07 实验反哺）
- [ ] QEMU 实验 15-21 逐一完成并落地
- [ ] QEMU 全部完成后重启 F103ZE 主线

---

## 紧急交接
<!-- 正常结束时此段为空。上下文即将耗尽时，在此写入断点信息。 -->
