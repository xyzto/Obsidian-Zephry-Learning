# Session Log — 会话状态日志

> 用途：每次对话结束前更新，新对话开始时第一件事就读这个文件。
> 让新 AI 无需依赖历史记录，直接定位当前状态。

---

## 最后更新：2026-03-22（第四次）

---

## 当前状态

### QEMU 实验进度
- ✅ 已完成：01 Hello World、02 线程基础、03 信号量、04 Mutex、05 消息队列、06 定时器、08 事件标志、09 内存池、10 栈溢出检测
- ⚠️ 07 工作队列跳过，占位文件已建，实验待做
- ⏭ **下一个：07 工作队列**
- 📁 实验记录位置：`02-Projects/QEMU/lab/`

### F103ZE
- 暂时搁置，等 QEMU 全部 22 个实验完成后再推进

### 最近一次操作（本次对话）
- 确定关键机制最终格式：按信息层次拆成多行，每行 `**标签名**：说明文字`
- 重写全部 6 个已完成实验的关键机制（Hello World、Thread-Basics、Seemaphore、MessageQueues、Heap、StackSentinel）
- 更新 format-rules.md：关键机制规范改为多行标签格式，模板同步更新
- 待办：刷新 study-context.md 的 FORMAT RULES 块

---

## 双 AI 工作流

| 角色 | AI | 工具 | 提示词 |
|------|----|------|--------|
| 仓库管理 | Claude（你） | MCP 读写文件 | `_manual/ai/vault-prompt.md` |
| 学习辅助 | 另一个 AI | 无 MCP | `_manual/ai/study-context.md` |

**分工：** 学习 AI 引导实验 → 用户带关键信息过来 → 你落地到仓库文件

---

## 实验落地标准流程

用户做完一个实验后会带来：目标 / 现象 / 结论 / 疑问 / 坑（可选）

你需要执行：
1. 在 `02-Projects/QEMU/lab/` 新建实验记录文件（格式见 `_manual/format-rules.md`）
2. 在 `02-Projects/QEMU/progress.md` 对应行打勾
3. 如有坑，补充进 `01-Concepts/` 对应 Concept 文件的 `## 坑` 里

---

## 下次对话开始时

1. 检查 `_manual/ai/handoff.md` 是否有交接内容
   - 有 → 优先读 handoff.md，按其指引定位
   - 无 → 读本文件定位
2. 确认状态后告诉用户，说明定位来源

---

## 待办事项

- [ ] 刷新 study-context.md 的 FORMAT RULES 块（format-rules.md 已更新）
- [ ] 确认 `Seemaphore.md` 文件名拼写（疑似应为 Semaphore.md）
- [ ] QEMU 实验 07、11-22 逐一完成并落地
- [ ] QEMU 全部完成后更新 study-context.md 的当前阶段描述
- [ ] QEMU 全部完成后重启 F103ZE 主线
