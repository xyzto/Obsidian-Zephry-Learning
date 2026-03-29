# Rules — 实验落地专用规则

> 用途：落地实验时，将此文件全文追加在 vault-prompt.md 粘贴区之后一起粘贴。
> 日常管理任务（清理、整理、刷新）不需要本文件。

---

## 实验落地标准流程（五步，必须完整执行）

用户带来：目标 / 现象 / 结论 / 疑问 / 坑（可选）

**步骤一：新建实验记录**
在 `02-Projects/QEMU/lab/` 新建文件，格式读 `_manual/format-rules.md`。

**步骤二：progress.md 打勾**
在 `02-Projects/QEMU/progress.md` 对应行打勾。

**步骤三：Concept 双向更新**
- 有坑 → 在对应 `01-Concepts/` 文件的 `## 坑` 追加
- 无论有无坑 → 在对应 Concept 的 `## 验证记录` 追加：`→ [[02-Projects/QEMU/lab/实验文件名]]`

**步骤四：Questions 状态检查**
扫描 `05-Questions/` 中与本实验相关的文件：
- 已能解答 → 更新状态为 `#已验证`，填写 `## 结论`
- 部分解答 → 在 `## 拆解` 追加本次发现

**步骤五：同步 study-context.md 进度**
将刚落地的实验在 `_manual/ai/study-context.md` 进度表中标为 ✅，更新"下一个要做的实验"。

完成后给出 git commit 命令。

---

## Question 文件联动规则

新建 Concept 时，若 `## 产生的问题` 不为空，必须同步在 `05-Questions/` 创建对应占位文件（状态 `#未解决`，其余留空）。不允许只写链接不建文件。
