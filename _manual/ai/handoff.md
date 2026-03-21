# Handoff — 对话交接文件

> 用途：上下文接近上限时由 AI 写入，供下一个对话的 AI 读取，实现无缝接续。
> 新对话开始时，若此文件有内容，优先读它，再读 session-log.md。
> 交接完成、确认新 AI 已定位后，可清空"## 交接状态"以下内容（保留模板结构）。

---

## 交接状态

**写入时间**：2026-03-21
**触发原因**：⚠️ 黄色警告——对话轮次极长（跨越多个主题），当前任务已完成

### 本次对话改动的文件

| 文件路径 | 操作 | 说明 |
|---------|------|------|
| `02-Projects/QEMU/lab/Mutex.md` | 修复 | 代码块格式问题：语言标识符、现象列表改为文字、坑格式规范化 |
| `_manual/format-rules.md` | 更新 | 新增"代码块"规范小节，禁止单独写语言名称行，补充现象部分规则 |
| `_manual/ai/study-context.md` | 更新 | BEGIN/END FORMAT RULES 块同步加入代码块规范和现象部分规则 |

### QEMU 实验进度

- ✅ 已完成：01 Hello World、02 线程基础、03 信号量、04 Mutex、05 消息队列
- ⏭ **下一个：06 定时器**
- 📁 lab/ 现有文件：`Hello World.md`、`Exp02-Thread-Basics.md`、`Seemaphore.md`、`Mutex.md`

### 未完成的任务

无，所有任务已完成。

### 需要注意的上下文

- `_manual/ai/` 子文件夹结构稳定，本次无变动
- format-rules.md 是唯一格式真相来源，study-context.md 里的 FORMAT RULES 块已与其同步
- Mutex.md 已修复，格式现在符合规范
- session-log.md 里记录的 `Seemaphore.md` 存在，需确认文件名拼写是否正确（疑似应为 Semaphore.md）

### 给下一个 AI 的指令

读完本文件后，告诉用户：
"已从 handoff.md 定位。上次修复了 Mutex.md 格式并更新了 format-rules.md。QEMU 进度 01-05 完成，下一个是 06 定时器。等你的指令。"
