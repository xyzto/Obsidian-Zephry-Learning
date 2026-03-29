# State — 仓库状态文件

> 用途：每次对话结束时无条件更新。新对话开始时第一件事就读这个文件。

---

## 最后更新：2026-03-29

---

## 上次摘要

2026-03-29：完成 vault 全面重构（分类路由+健康检查+文件合并+模板去领域化），下次直接开始实验 15 设备树覆盖。

---

## 当前进度

### QEMU 实验
- ✅ 第一层全部完成（10/10）
- ✅ 第二层部分完成（4/6）：11 UART 基础、12 UART 中断、13 GPIO 模拟、14 驱动模型阅读
- ⏭ **下一个：15 设备树覆盖**

### F103ZE
- 暂时搁置，等 QEMU 全部完成后推进

---

## 健康度快照（2026-03-29）

- Inbox 文件数：3（正常）
- 空壳 Concepts：2 个（`GDB.md`、`k_event.md`，待实验反哺）
- #已验证 待提炼为 Concept：0
- README 同步状态：已同步（21 个）

---

## 待办

- [ ] 补全 `01-Concepts/GDB.md`（待实验后填充）
- [ ] 补全 `01-Concepts/k_event.md`（待 Exp07 反哺）
- [ ] QEMU 实验 15-21 逐一完成并落地
- [ ] QEMU 全部完成后重启 F103ZE 主线

---

## 最近操作

### 2026-03-29 — Vault 二次重构（四需求优化）

- `vault-prompt.md` 拆分为启动层（~60行）+ `rules-landing.md`（落地专用）
- `handbook.md` 合并 structure.md + new-project-guide.md，删除原两文件
- `state.md` 新增"上次摘要"和"健康度快照"字段
- `_templates/Concept.md` 去领域化（`## 在 Zephyr 里怎么用` → `## 用法`，`## 与相关概念的区别` → `## 对比`）
- `_manual/` 从 7 个文件减至 5 个（删 structure.md、new-project-guide.md）
- Inbox 文件 `致力于Claude_MCP高效利用管理仓库.md` 需求已执行，待删除

---

## 紧急交接
<!-- 正常结束时此段为空 -->
