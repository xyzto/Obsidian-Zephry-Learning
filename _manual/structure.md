# Structure — 仓库结构说明

> 英文文件名对照中文含义，换电脑或长时间未用时快速找回方向
> 根路径见：`_manual/ai/vault-root.md`（换电脑只改这一个文件）

---

## 顶层目录

| 目录 | 含义 | 用途 |
|------|------|------|
| `00-Inbox/` | 收件箱 | 灵光一现随手捕获，不要求完整，48h 内清理 |
| `01-Concepts/` | 概念库 | 知识原子，扁平存放，一个文件一个概念 |
| `02-Projects/` | 项目 | 按硬件平台分项目文件夹 |
| `03-Areas/` | 领域 | 学科总览和进度导航，只做索引 |
| `04-Resources/` | 资源 | 外部链接、参考资料 |
| `05-Questions/` | 问题 | 整理成型的问题，有猜测有拆解 |
| `assets/` | 附件 | 图片、PDF 等附件自动存放 |
| `_templates/` | 模板 | Obsidian 新建笔记时套用 |
| `_manual/` | 手册 | 系统操作手册、脚本工具和配置备份 |

---

## `02-Projects/<项目名>/` 子文件

| 文件 | 含义 | 用途 |
|------|------|------|
| `plan.md` | 学习计划 | 该项目的阶段规划和每日任务 |
| `progress.md` | 进度 | 打勾记录，唯一进度来源 |
| `env.md` | 环境信息 | 硬件引脚表、烧录方式、构建命令 |
| `lab/` | 实验目录 | 每个实验一个文件，按编号命名 |

---

## `_manual/` 系统手册

### 人工参考手册

| 文件 | 含义 | 用途 |
|------|------|------|
| `format-rules.md` | 笔记格式规范 | 新建文件时对照，两份 AI 提示词共用 |
| `handbook.md` | 知识库维护手册 | 完整方法论设计文档，通用版本 |
| `structure.md` | 仓库结构说明 | 本文件 |
| `new-project-guide.md` | 新建项目说明 | 新增开发板时的标准流程 |
| `git-guide.md` | Git 使用说明 | workspace 与 learning 仓库分离方案 |
| `obsidian-config.md` | Obsidian 配置 | 插件、快捷键配置备份 |
| `new-project.ps1` | 新建项目脚本 | PowerShell 脚本，自动生成项目文件夹结构 |

### AI 运行时文件（`_manual/ai/`）

| 文件 | 含义 | 用途 |
|------|------|------|
| `vault-root.md` | 根路径声明 | 换电脑只改这一个文件，所有路径从此派生 |
| `vault-prompt.md` | 仓库管理提示词 | 开启新对话时粘贴，用于仓库管理（Claude） |
| `session-log.md` | 会话日志 | 每次对话结束前更新，新对话开始时读取定位 |
| `handoff.md` | 对话交接文件 | 上下文接近上限时写入，供下个窗口的 AI 接续 |
| `study-prompt.md` | 学习辅助提示词 | 原始版本，维护用 |
| `study-context.md` | 学习辅助完整上下文 | 给学习 AI 看的合并版，复制一次即用 |

---

## `_templates/` 模板

| 文件 | 含义 | 触发快捷键 |
|------|------|-----------|
| `Inbox.md` | 捕获模板 | `Ctrl+Shift+I` |
| `Concept.md` | 概念模板 | `Ctrl+Shift+C` |
| `Question.md` | 问题模板 | `Ctrl+Shift+Q` |
| `Project.md` | 实验记录模板 | `Ctrl+Shift+P` |

---

## 信息流向

```
00-Inbox  →  05-Questions  →  01-Concepts
  捕获           提问              沉淀
```
