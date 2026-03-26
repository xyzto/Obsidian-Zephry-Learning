# State — 仓库状态文件

> 用途：每次对话结束时无条件更新。新对话开始时第一件事就读这个文件。
> 替代原来的 session-log.md 和 handoff.md，统一管理所有状态。

---

## 最后更新：2026-03-26

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

- 工作流重构：合并 session-log + handoff → `state.md`
- 更新 `_templates/Concept.md`：新增 `## 验证记录` 字段
- 重写 `_manual/ai/vault-prompt.md`：精简启动流程、修正 MCP 工具名、新增 Inbox 自动检查、落地五步流程（含 Questions 状态联动 + study-context 强制同步）
- 重写 `_manual/ai/study-prompt.md`：进度表同步至真实状态（V3.0）、阶段 6 加入仓库 AI 落地提醒
- 重写 `_manual/ai/study-context.md`：同步所有以上改动、Concept 模板加入验证记录字段
- 删除 `_manual/ai/session-log.md` 和 `_manual/ai/handoff.md`

---

## 下一步

- 继续 QEMU 实验 15 设备树覆盖
- 清理 00-Inbox（见待办）

---

## 待办

- [ ] 清理 00-Inbox：删除 `Study-Prompt.md`、`4000字.md`（prompt 草稿），合并 Windows 注册表两个重复文件，Zephyr 相关内容流转到 Questions
- [ ] 合并或确认 `01-Concepts/Workqueue.md` 与 `k_work.md` 是否重复
- [ ] 将 `01-Concepts/EventFlags.md` 重命名为 `k_event.md` 消除歧义
- [ ] 检查 `05-Questions/优先级翻转如何发生？.md` 状态是否应标为已解决
- [ ] QEMU 实验 15-21 逐一完成并落地
- [ ] QEMU 全部完成后重启 F103ZE 主线

---

## 紧急交接
<!-- 正常结束时此段为空。上下文即将耗尽时，在此写入断点信息。 -->
