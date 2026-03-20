# Session Log — 会话状态日志

> 用途：每次对话结束前更新，新对话开始时第一件事就读这个文件。
> 让新 AI 无需依赖历史记录，直接定位当前状态。

---

## 最后更新：2026-03-20

---

## 当前状态

### QEMU 实验进度
- ✅ 已完成：01 Hello World、02 线程基础、03 信号量、04 Mutex、05 消息队列
- ⏭ **下一个：06 定时器**
- 📁 实验记录位置：`02-Projects/QEMU/lab/`
- 已有文件：`Hello World.md`、`Exp02-Thread-Basics.md`

### F103ZE
- 暂时搁置，等 QEMU 全部 22 个实验完成后再推进

### 最近一次操作
- 新建 `_manual/vault-root.md`：根路径单一真相源，换电脑只改这一个文件
- 更新 `_manual/vault-prompt.md`：移除所有硬编码绝对路径，改为读 vault-root.md 后拼接
- 更新 `_manual/new-project-guide.md`：移除硬编码路径，引用 vault-root.md
- 更新 `_manual/structure.md`：新增 vault-root.md 和 handoff.md 条目

---

## 双 AI 工作流

| 角色   | AI        | 工具       | 提示词                        |
| ---- | --------- | -------- | -------------------------- |
| 仓库管理 | Claude（你） | MCP 读写文件 | `_manual/vault-prompt.md`  |
| 学习辅助 | 另一个 AI    | 无 MCP    | `_manual/study-context.md` |

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

1. 读 `_manual/vault-root.md` 获取 VAULT_ROOT
2. 检查 `_manual/handoff.md` 是否有交接内容
   - 有 → 优先读 handoff.md，按其指引定位
   - 无 → 读 session-log.md（本文件）定位
3. 确认状态后告诉用户，说明定位来源

---

## 待办事项

- [ ] QEMU 实验 06-22 逐一完成并落地
- [ ] QEMU 全部完成后更新 study-context.md 的当前阶段描述
- [ ] QEMU 全部完成后重启 F103ZE 主线
