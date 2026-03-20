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
- 已有文件：`Hello World.md`、`Exp02-Thread-Basics.md`、`Seemaphore.md`

### F103ZE
- 暂时搁置，等 QEMU 全部 22 个实验完成后再推进

### 最近一次操作（本次对话）
- 删除 `_manual/ai/study-prompt.md`（内容已被 study-context.md 完全覆盖，用 git rm 删除）
- 更新 `vault-prompt.md` 目录结构，删除 study-prompt.md 条目
- 重写 `README.md`，加入各目录详细介绍和现有文件清单
- 多轮重构 `study-context.md`，最终版本为 V2.1，包含：
  - 六阶段实验节奏（含自我复盘阶段）
  - 结构化讲解输出【1】-【6】
  - 调试三级递进（现象/配置/源码）
  - 模式控制（beginner/engineer/debug/system）
  - 源码最小阅读规则
  - 掌握能力判断标准
  - 纯净输出规则（含代码块格式、反哺路径规则）
- 修复 `Seemaphore.md` 五类格式问题（对话残留/代码块标注/空行/反哺路径）
- 更新 `Seemaphore.md` 反哺链接加路径前缀

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

1. 读 `_manual/ai/vault-root.md` 获取 VAULT_ROOT
2. 检查 `_manual/ai/handoff.md` 是否有交接内容
   - 有 → 优先读 handoff.md，按其指引定位
   - 无 → 读 `_manual/ai/session-log.md`（本文件）定位
3. 确认状态后告诉用户，说明定位来源

---

## 待办事项

- [ ] 执行 `git rm _manual/ai/study-prompt.md` 删除冗余文件
- [ ] QEMU 实验 06-22 逐一完成并落地
- [ ] QEMU 全部完成后更新 study-context.md 的当前阶段描述
- [ ] QEMU 全部完成后重启 F103ZE 主线
