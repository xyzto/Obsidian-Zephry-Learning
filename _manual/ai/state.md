# State — 仓库状态文件

> 用途：每次对话结束时无条件更新。新对话开始时第一件事就读这个文件。
> 替代原来的 session-log.md 和 handoff.md，统一管理所有状态。

---

## 最后更新：2026-03-27

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

- 清理 00-Inbox：删除 `4000字.md`、`Study-Prompt.md`（prompt 草稿）、`Windows 注册表 vs 系统变量.md`（与「环境变量」版重复）
- 流转 Zephyr 文件：
  - `STM32F407在Zephyr的支持情况.md` → `05-Questions/`
  - `Zephyr2026实际情况的嵌入式选型参考.md` → `05-Questions/`
  - `Zephyr不支持市场常见板原因.md` → `05-Questions/`
  - `什么是 Zephyr 子系统.md` → `01-Concepts/Zephyr子系统.md`

---

## 下一步

- 继续 QEMU 实验 15 设备树覆盖
- 处理 00-Inbox 剩余文件（见待办）

---

## 待办

- [ ] 处理 00-Inbox 剩余文件：`GDB.md`、`从 HAL 库思维切换到 RTOS 思维.md`、`落地的第一版工程骨架.md`（归属未定）
- [ ] 合并或确认 `01-Concepts/Workqueue.md` 与 `k_work.md` 是否重复
- [ ] 将 `01-Concepts/EventFlags.md` 重命名为 `k_event.md` 消除歧义
- [ ] 检查 `05-Questions/优先级翻转如何发生？.md` 状态是否应标为已解决
- [ ] QEMU 实验 15-21 逐一完成并落地
- [ ] QEMU 全部完成后重启 F103ZE 主线

---

## 紧急交接
<!-- 正常结束时此段为空。上下文即将耗尽时，在此写入断点信息。 -->
