# Zephyr 嵌入式知识库

从 STM32 HAL 转向 Zephyr RTOS 的学习记录

**工作流：**
- 实验用另一个 AI 辅助（粘贴 `_manual/ai/study-context.md`），负责讲解、调试、生成笔记草稿
- 笔记落地用 Claude + MCP（粘贴 `_manual/ai/vault-prompt.md`），负责读写文件、维护仓库
- 格式规范统一在 `_manual/format-rules.md`，两个 AI 共用

---

## 正在进行

- QEMU 实验：✅ 第一层 10/10、第二层 4/6 已完成，⏭ 下一个：15 设备树覆盖 → [[02-Projects/QEMU/progress]]
- F103ZE 真实硬件：暂时搁置，等 QEMU 全部跑完再推进 → [[02-Projects/F103ZE/progress]]

---

## 目录结构一览

```
00-Inbox/       随手捕获，灵光一现
01-Concepts/    知识原子，扁平存放
02-Projects/    按平台分项目（QEMU / F103ZE）
03-Areas/       领域导航（规划中）
04-Resources/   外部链接和参考资料索引（不放正文内容）
05-Questions/   整理后的问题（有待验证的结论）
_templates/     笔记模板
_manual/        操作手册、脚本工具、AI 提示词
```

---

## 各目录详解

### 00-Inbox — 随手捕获

**放什么：** 灵光一现、还没想清楚的念头、临时记录。不要求格式，一句话也行。

**下一步：** 想清楚后移到 `05-Questions/`，或直接升级为 `01-Concepts/`。

---

### 01-Concepts — 知识原子

**放什么：** 一个概念一个文件，结论明确、内容完整自洽的稳定知识。格式见 `_manual/format-rules.md`。

**规则：** 严禁建子文件夹，所有概念平铺在这一层。

**现在有：**

| 文件 | 内容 |
|------|------|
| `West.md` | Zephyr 的工作区管理工具，类似 repo |
| `CMake.md` | Zephyr 构建系统的核心，负责编译配置 |
| `Kconfig.md` | 内核功能开关，控制编译哪些模块 |
| `DeviceTree.md` | 硬件描述语言，替代 HAL 的硬件绑定方式 |
| `Overlay.md` | DeviceTree 的覆盖层，用于板级定制 |
| `Zephyr.md` | Zephyr RTOS 整体概念入口 |
| `Zephyr编译系统.md` | West / CMake / Kconfig / DTS 的协作关系 |
| `Zephyr启动与设备初始化.md` | 从上电到 main() 的启动流程 |
| `Zephyr开发流程.md` | 日常开发的标准操作流程 |
| `Zephyr子系统.md` | Zephyr 子系统全景：Shell / Logging / FS / Net |
| `Thread.md` | 线程创建、调度、优先级、IPC 机制概览 |
| `ThreadPriority.md` | 优先级数值规则、抢占式/协作式、时间片轮转 |
| `Semaphore.md` | 信号量核心机制、二值与计数类型、与 Mutex 的区别 |
| `Mutex.md` | 互斥锁、所有权语义、优先级继承机制 |
| `Priority_Inversion.md` | 优先级翻转成因与 Zephyr 的优先级继承解法 |
| `MessageQueue.md` | k_msgq 消息队列、生产者-消费者模型、有界缓冲 |
| `QEMU.md` | QEMU 仿真环境配置与使用 |
| `GDB.md` | GDB 调试基础、QEMU 调试与实板调试方式 |
| `k_work.md` | 工作队列项，延迟/异步执行，bottom half 模式 |
| `k_event.md` | 事件标志对象（待填充） |
| `DEVICE_DT_DEFINE.md` | Zephyr 驱动注册宏与设备初始化机制 |

---

### 02-Projects — 实验项目

**放什么：** 按硬件平台分文件夹，每个实验一个记录文件。

**子目录结构（每个项目相同）：**
```
02-Projects/<平台>/
├── plan.md       学习计划
├── progress.md   实验进度，做完打勾
├── env.md        环境配置记录
└── lab/          实验记录文件，每个实验一个 .md
```

**QEMU（当前主力）：**
- 目标：跑完 22 个实验，覆盖内核机制 / 驱动模拟 / 子系统
- 进度：第一层 10/10 ✅，第二层 4/6 ✅

**F103ZE（暂时搁置）：**
- 目标：在自制 STM32F103ZE 板上跑通 Zephyr，作为简历项目
- 等 QEMU 全部完成后推进

---

### 03-Areas — 领域导航

**放什么：** 跨项目的领域级知识导航，例如"STM32 知识图谱"、"嵌入式面试地图"。

**现状：** 规划中，暂无内容。

---

### 04-Resources — 外部资源索引

**放什么：** 外部链接、文档索引、教材摘要。**只放指向外部的引用，不放自己编写的正文内容或代码。**

**现在有：**
- `外部链接汇总.md`：常用文档、源码仓库链接
- `进阶方向.md`：Zephyr 学完后的可选方向

---

### 05-Questions — 整理后的问题

**放什么：** 有待验证、结论尚不明确的问题。一旦有了明确结论，提炼到 `01-Concepts/` 或在此文件填写结论并标记 `#已验证`。

**现在有：**

| 文件 | 状态 |
|------|------|
| `prjconf配置推导方法.md` | #已验证 |
| `Zephyr开发是不是伪命题.md` | #已验证 |
| `如何为STM32F103ZE创建自定义Board.md` | #进行中 |
| `线程调度相关问题集.md` | #已验证 |
| `驱动程序如何与硬件通信.md` | 待验证 |
| `优先级翻转如何发生？.md` | #已验证 |
| `什么时候该用信号量而不是互斥锁？.md` | #已验证 |
| `中断风暴 (Interrupt Storm).md` | 待验证 |
| `Zephyr初始化为什么不需要手动调用外设Init.md` | 待验证 |
| `STM32F407在Zephyr的支持情况.md` | #已验证 |
| `Zephyr2026实际情况的嵌入式选型参考.md` | #已验证 |
| `Zephyr不支持市场常见板原因.md` | 待验证 |
| `生产者-消费者模型在实际开发中解决的典型问题.md` | → 已提炼为 [[01-Concepts/MessageQueue]] |

---

### _templates — 笔记模板

| 模板 | 用于 |
|------|------|
| `Concept.md` | 新建知识概念文件 |
| `Question.md` | 新建问题文件 |
| `Project.md` | 新建项目 |
| `Inbox.md` | 随手捕获 |

---

### _manual — 操作手册与 AI 工具

**放什么：** 人工参考手册、脚本工具、AI 提示词。不放学习内容。

#### 人工参考

| 文件 | 用途 |
|------|------|
| `format-rules.md` | 笔记格式规范（唯一真相来源），新建文件时对照 |
| `handbook.md` | 知识库维护原则，仓库整理时参考 |
| `structure.md` | 目录结构详细说明 |
| `new-project-guide.md` | 新建项目的操作步骤 |
| `new-project.ps1` | 自动生成项目文件夹结构的 PowerShell 脚本 |
| `git-guide.md` | Git 提交规范和常用命令 |
| `obsidian-config.md` | Obsidian 插件和配置备份 |

#### AI 运行时文件（`_manual/ai/`）

| 文件 | 用途 | 使用时机 |
|------|------|---------|
| `vault-root.md` | 仓库根路径声明，换电脑只改这一个文件 | MCP 环境下 AI 无需读取 |
| `state.md` | 唯一状态文件，替代原 session-log + handoff | 每次对话必读必写 |
| `vault-prompt.md` | 仓库管理 AI（Claude + MCP）的提示词 | 新开仓库管理对话时粘贴 |
| `study-context.md` | 学习辅助 AI 的完整上下文（自动维护） | 新开学习对话时粘贴 |
| `study-prompt.md` | study-context.md 的源文件，不直接使用 | 修改学习流程时编辑，改完执行"刷新 study-context" |

---

## 知识流转规则

```
00-Inbox（随手捕获）
    ↓ 想清楚了
05-Questions（整理成有待验证的问题）
    ↓ 结论明确
01-Concepts（沉淀为完整知识）
```

做完实验 → `02-Projects/<平台>/lab/` 新建记录，`progress.md` 打勾
遇到报错 → `01-Concepts/<相关概念>.md` 补一条 `## 坑`

---

## 快速上手

| 发生了什么 | 做什么 |
|-----------|--------|
| 灵光一现，还没想清楚 | 丢进 `00-Inbox/`，文件名就是那个想法 |
| 想清楚了，整理成问题 | 从 Inbox 移到 `05-Questions/`，补猜测和拆解 |
| 学了新概念 | 打开或新建 `01-Concepts/[概念名].md` |
| 做完一个实验 | `lab/` 新建记录文件，`progress.md` 打勾 |
| 遇到报错 | 回到对应 Concept 文件，补 `## 坑` |
| 找到外部好资料 | 链接存进 `04-Resources/外部链接汇总.md` |
| 开新 AI 对话（仓库管理） | 粘贴 `_manual/ai/vault-prompt.md` 内容 |
| 开新 AI 对话（学习辅助） | 粘贴 `_manual/ai/study-context.md` 内容 |
| 修改了 format-rules.md | 告诉仓库 AI "刷新 study-context" |
