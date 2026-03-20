# Handoff — 对话交接文件

> 用途：上下文接近上限时由 AI 写入，供下一个对话的 AI 读取，实现无缝接续。
> 新对话开始时，若此文件有内容，优先读它，再读 session-log.md。
> 交接完成、确认新 AI 已定位后，可清空"## 交接状态"以下内容（保留模板结构）。

---

## 交接状态

**写入时间**：2026-03-20
**触发原因**：⚠️ 黄色警告——对话轮次长，文件读取多，当前任务已完成

### 本次对话改动的文件

| 文件路径 | 操作 | 说明 |
|---------|------|------|
| `_manual/ai/`（新建文件夹） | 创建 | AI 运行时文件专用子文件夹 |
| `_manual/ai/vault-prompt.md` | 从 `_manual/` 移入并更新 | 所有路径引用改为 `_manual\ai\` |
| `_manual/ai/study-prompt.md` | 从 `_manual/` 移入 | 无改动 |
| `_manual/ai/study-context.md` | 从 `_manual/` 移入 | 无改动 |
| `_manual/ai/handoff.md` | 从 `_manual/` 移入 | 本文件 |
| `_manual/ai/session-log.md` | 从 `_manual/` 移入并更新 | 路径引用同步更新 |
| `_manual/ai/vault-root.md` | 从 `_manual/` 移入 | 无改动 |
| `_manual/new-project.ps1` | 从 `02-Projects/` 移入 | 工具脚本归入系统手册 |
| `_manual/structure.md` | 更新 | 同步 ai/ 子文件夹结构，加入 new-project.ps1 条目 |
| `README.md` | 更新（两次） | 新增 `_manual/` 文件说明表格；加入 new-project.ps1 条目 |

### QEMU 实验进度

- 已完成：01–05
- **下一个：06 定时器**

### 未完成的任务

无。本次对话全部为仓库结构整理，无实验落地任务。

### 需要注意的上下文

- `_manual/ai/` 分类已完全执行完毕，结构稳定
- `02-Projects/` 内部结构（plan/progress/env/lab）无变动
- `_templates/` 无变动
- `new-project.ps1` 里有一行硬编码路径 `E:\OB-Vaults\Zephry\02-Projects\$name`，换电脑后需要手动修改（或改为读 vault-root.md，但目前未处理，留作以后优化）

### 给下一个 AI 的指令

读完本文件后，告诉用户：
"已从 handoff.md 定位。本次仓库整理全部完成，结构已稳定。QEMU 进度 01-05，下一个是 06 定时器。等你的指令。"
