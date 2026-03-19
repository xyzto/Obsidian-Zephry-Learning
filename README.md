# 知识库索引

> 创建于 2026-03 | 管理原则：原子化 · 可链接 · 可演化

这是一个以 **Zephyr RTOS** 学习为核心的嵌入式工程知识库，使用 Obsidian + Git 管理。

---

## 目录结构

```
00-Inbox/       输入缓冲区：零碎想法、待整理内容，每周清空
01-Concepts/    原子化概念库：每个文件只讲一件事
02-Projects/    当前执行项目
03-Areas/       长期关注领域
04-Resources/   参考资料与外部链接
05-Questions/   问题驱动笔记
```

**使用原则：**
- 不允许直接写 `01-Concepts`，必须先经过 `05-Questions`
- 链接代替层级：用 `[[概念名]]` 建立关联，不用子文件夹
- 有想法先丢 `00-Inbox`，每周集中处理一次

---

## 01-Concepts 概念库

### Zephyr 核心

| 文件 | 内容 |
|------|------|
| [[Zephyr]] | Zephyr 总览：四大部件、五层架构、源码目录结构 |
| [[Zephyr编译系统]] | 四阶段构建：配置合并 → 代码生成 → 编译 → 链接 |
| [[Zephyr启动流程]] | 从复位向量到 main，SYS_INIT 自动初始化机制 |
| [[Zephyr开发流程]] | 标准五步法、Board Bring-up、四层推导框架 |
| [[调用驱动函数硬件启动]] | DEVICE_DT_DEFINE → 设备表遍历 → 驱动 init 完整链条 |

### 构建工具链

| 文件 | 内容 |
|------|------|
| [[CMake]] | 构建系统生成器原理、与 Make 的区别、Zephyr 中的角色 |
| [[West]] | 多仓库管理、常用命令、工作流 |
| [[Kconfig]] | 功能开关系统、prj.conf 写法、menuconfig 使用 |
| [[Zephyr编译系统]] | 编译四阶段详解，构建产物说明 |
| [[QEMU]] | 虚拟仿真器使用，零硬件调试方法 |

### 硬件抽象

| 文件 | 内容 |
|------|------|
| [[DeviceTree]] | 硬件描述语言，节点/属性/compatible 概念 |
| [[Overlay]] | 应用级硬件补丁，万能模板，四步开发流程，避坑清单 |

### RTOS 基础

| 文件 | 内容 |
|------|------|
| [[Thread]] | 线程本质、RTOS Task、Zephyr 线程 API、同步机制 |

### 其他技术

| 文件 | 内容 |
|------|------|
| [[Docker]] | 容器化笔记 |
| [[RT-Thread]] | RT-Thread RTOS 对比参考 |

---

## 02-Projects 项目

### 30天 Zephyr 工程师训练计划

- [[02-Projects/30day-Zephyr/30天Zephyr工程师训练计划|训练计划总览]]
- [[02-Projects/30day-Zephyr/基于F103改写|基于F103改写思路]]
- `日记/Day01.md` ～ `日记/Day30.md` — 每日学习记录

**训练阶段：**

| 天数 | 阶段重点 |
|------|---------|
| Day01-10 | 构建系统基础：CMake / Kconfig / Devicetree / West |
| Day11-20 | 多线程：Thread / Semaphore / Mutex / Queue |
| Day21-30 | 驱动与子系统深入 |

---

## 03-Areas 长期领域

| 文件 | 内容 |
|------|------|
| [[03-Areas/Zephyr-RTOS|Zephyr-RTOS]] | 学习进度追踪、核心知识地图 |
| [[03-Areas/STM32知识图谱|STM32知识图谱]] | 建模目标、概念清单、问题列表、实验路线 |

---

## 04-Resources 参考资料

| 文件 | 内容 |
|------|------|
| [[04-Resources/Zephyr-Git仓库使用说明|Zephyr Git 仓库]] | workspace 与 learning 仓库的分离方案 |
| [[04-Resources/Obsidian使用指南|Obsidian 使用指南]] | Vault 管理、插件推荐、同步方案 |
| [[04-Resources/硬件进阶路线|硬件进阶路线]] | 芯片设计、边缘AI、运动控制进阶方向 |
| [[04-Resources/开源项目推荐|开源项目推荐]] | SimpleFOC / QMK / OpenAstroTracker 等 |
| [[04-Resources/Zephyr学习系统外链|Zephyr 学习系统]] | 外部在线学习资源链接 |

---

## 05-Questions 问题驱动

| 文件 | 问题 |
|------|------|
| [[05-Questions/驱动程序如何与硬件通信|驱动程序如何与硬件通信]] | Devicetree → 驱动 → 寄存器的完整路径 |
| [[05-Questions/prjconf配置推导方法|prjconf 配置推导方法]] | 如何从零推导 prj.conf 和 app.overlay |

---

## 00-Inbox 待处理

> 每周清空一次，内容提炼到对应区域后删除。

**待整理（有价值，需提炼）：**
- `知识管理方法论.md` — 已提炼完成，可考虑归入 04-Resources
- `学习正则表达式.md` — 与当前领域无关，考虑新建正则表达式领域或删除

**旧稿存档（已被新文件替代，确认后可删除）：**
- `旧稿-Zephyr.md` / `旧稿-Zephyr2.md` → 已合并入 `01-Concepts/Zephyr.md`
- `旧稿-CMake原版.md` / `旧稿-CMake-review.md` → 已合并入 `01-Concepts/CMake.md`
- `旧稿-开发流程1.md` / `旧稿-开发流程2.md` → 已合并入 `01-Concepts/Zephyr开发流程.md`
- `旧稿-Overlay语法*.md` (6个) → 已合并入 `01-Concepts/Overlay.md`
- `旧稿-Thread.md` / `旧稿-RTOS-Thread.md` → 已合并入 `01-Concepts/Thread.md`
- `AI文档-*.md` (6个) → 已提炼入 `知识管理方法论.md`

---

## Git Commit 规范

```bash
feat(concept): 新增笔记 [概念名]
update(concept): 重构 [概念名]，补充 xxx
merge(concept): 合并 [文件A] 与 [文件B]
move: 迁移 [文件名] 至正确目录
fix(concept): 修正 [概念名] 中的错误理解
link(concept): 建立 [A] 与 [B] 的关联
test(project): 验证 [实验名称]
```

---

## 知识图谱关系速查

```
Zephyr
  ├── 构建链：West → CMake → Kconfig → DeviceTree → Ninja
  ├── 硬件抽象：DeviceTree + Overlay
  ├── 运行时：Thread + Zephyr启动流程 + 调用驱动函数硬件启动
  └── 工程实践：Zephyr开发流程 + Zephyr编译系统

STM32（待建设）
  └── CPU → 总线结构 → 中断机制 / DMA → USART / GPIO / 定时器
```
