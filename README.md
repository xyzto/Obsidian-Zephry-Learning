# Zephyr 嵌入式知识库

从 STM32 HAL 转向 Zephyr RTOS 的学习记录

**工作流：**
- 实验用另一个 AI 辅助（粘贴 `_manual/ai/study-context.md`），负责讲解、调试、生成笔记草稿
- 笔记落地用 Claude + MCP（粘贴 `_manual/ai/vault-prompt.md`），负责读写文件、维护仓库
- 格式规范统一在 `_manual/format-rules.md`，两个 AI 共用

---

## 正在进行

- QEMU 实验：✅ 01-05 已完成，⏭ 下一个：06 定时器 → [[02-Projects/QEMU/progress]]
- F103ZE 真实硬件：暂时搁置，等 QEMU 全部跑完再推进 → [[02-Projects/F103ZE/progress]]

---

## 目录结构一览

```
00-Inbox/       随手捕获，灵光一现
01-Concepts/    知识原子，扁平存放
02-Projects/    按平台分项目（QEMU / F103ZE）
03-Areas/       领域导航（规划中）
04-Resources/   外部链接和参考资料
05-Questions/   整理后的问题
_templates/     笔记模板
_manual/        操作手册、脚本工具、AI 提示词
```

---

## 各目录详解

### 00-Inbox — 随手捕获

**放什么：** 灵光一现、还没想清楚的念头、临时记录。不要求格式，一句话也行。

**现在有：**
- 从 HAL 库思维切换到 RTOS 思维

**下一步：** 想清楚后移到 `05-Questions/`，或直接升级为 `01-Concepts/`。

---

### 01-Concepts — 知识原子

**放什么：** 一个概念一个文件，沉淀后的稳定知识。格式见 `_manual/format-rules.md`。

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
| `Thread.md` | 线程创建、调度、优先级、信号量 / Mutex / 消息队列 |
| `Semaphore.md` | 信号量核心机制、二值与计数类型、与 Mutex 的区别 |
| `QEMU.md` | QEMU 仿真环境配置与使用 |

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
- 进度：01 Hello World ✅、02 线程基础 ✅、03-05 同步原语 ✅
- lab/ 已有：`Hello World.md`、`Exp02-Thread-Basics.md`

**F103ZE（暂时搁置）：**
- 目标：在自制 STM32F103ZE 板上跑通 Zephyr，作为简历项目
- 等 QEMU 全部完成后推进

---

### 03-Areas — 领域导航

**放什么：** 跨项目的领域级知识导航，例如"STM32 知识图谱"、"嵌入式面试地图"。

**现状：** 规划中，暂无内容。

---

### 04-Resources — 外部资源

**放什么：** 外部链接、文档、参考资料、进阶方向。不放正文内容，只放索引和链接。

**现在有：**
- `外部链接汇总.md`：常用文档、源码仓库链接
- `进阶方向.md`：Zephyr 学完后的可选方向

---

### 05-Questions — 整理后的问题

**放什么：** 从 Inbox 升级来的、已经想清楚如何拆解的问题。有猜测、有验证方式，驱动后续学习。

**现在有：**

| 文件 | 问题 |
|------|------|
| `prjconf配置推导方法.md` | prj.conf 里的配置项怎么找、怎么确认 |
| `Zephyr开发是不是伪命题.md` | 真实项目中 Zephyr 的可行性讨论 |
| `如何为STM32F103ZE创建自定义Board.md` | 自定义 Board 的完整流程 |
| `线程调度相关问题集.md` | 优先级 / 时间片 / 协作式调度的疑问 |
| `驱动程序如何与硬件通信.md` | Zephyr 驱动框架与底层硬件的绑定机制 |
| `优先级翻转如何发生？.md` | 优先级翻转的触发条件与 Zephyr 的应对机制 |
| `什么时候该用信号量而不是互斥锁？.md` | 信号量与 Mutex 的使用场景边界 |

---

### _templates — 笔记模板

**放什么：** Obsidian 新建笔记时用的模板文件。

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
| `vault-root.md` | 仓库根路径声明，换电脑只改这一个文件 | AI 启动时自动读取 |
| `vault-prompt.md` | 仓库管理 AI（Claude + MCP）的提示词 | 新开仓库管理对话时粘贴 |
| `study-context.md` | 学习辅助 AI 的完整上下文（自动维护） | 新开学习对话时粘贴 |
| `study-prompt.md` | study-context.md 的源文件，不直接使用 | 修改学习流程时编辑，改完执行"刷新 study-context" |
| `session-log.md` | AI 会话状态日志，记录上次做到哪 | AI 每次对话结束时自动更新 |
| `handoff.md` | 对话交接文件，上下文到限时写入 | AI 上下文紧张时自动触发 |

---

## 知识流转规则

```
00-Inbox（随手捕获）
    ↓ 想清楚了
05-Questions（整理成问题）
    ↓ 找到答案
01-Concepts（沉淀为知识）
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
