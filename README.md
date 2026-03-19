# 知识库索引

> 创建于 2026-03 | 管理原则：原子化 · 可链接 · 可演化

这是一个以 **Zephyr RTOS** 学习为核心的嵌入式工程知识库，使用 Obsidian + Git 管理。

---

## 目录结构

```
_templates/     笔记模板（系统文件）
_维护/          仓库维护手册（系统文件）
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
| [[Zephyr]] | 总览：四大部件、五层架构、源码目录结构 |
| [[Zephyr编译系统]] | 四阶段构建：配置合并 → 代码生成 → 编译 → 链接 |
| [[Zephyr启动与设备初始化]] | 从复位到 main，DEVICE_DT_DEFINE，设备自动初始化 |
| [[Zephyr开发流程]] | 标准五步法、Board Bring-up、四层推导框架 |

### 构建工具链

| 文件 | 内容 |
|------|------|
| [[CMake]] | 构建系统生成器原理、与 Make 的区别 |
| [[West]] | 多仓库管理、常用命令、何时加 -p always |
| [[Kconfig]] | 功能开关系统、prj.conf 写法、menuconfig |
| [[QEMU]] | 虚拟仿真器、调试优势、局限性 |

### 硬件抽象

| 文件 | 内容 |
|------|------|
| [[DeviceTree]] | 硬件描述语言，节点/属性/compatible/DT宏 |
| [[Overlay]] | 应用级硬件补丁，万能模板，四步开发流程 |

### RTOS 基础

| 文件 | 内容 |
|------|------|
| [[Thread]] | 线程本质、RTOS Task、Zephyr 线程 API、同步机制 |

---

## 02-Projects 项目

### 30天 Zephyr 工程师训练计划

- [[02-Projects/30day-Zephyr/30天Zephyr工程师训练计划|训练计划总览]]
- [[02-Projects/30day-Zephyr/基于F103改写|基于F103改写思路]]
- `日记/Day01.md` ～ `日记/Day30.md` — 每日学习记录

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
| [[04-Resources/硬件进阶路线|硬件进阶路线]] | 芯片设计、边缘AI、运动控制进阶方向 |
| [[04-Resources/开源项目推荐|开源项目推荐]] | SimpleFOC / QMK / OpenAstroTracker 等 |
| [[04-Resources/外部链接汇总|外部链接汇总]] | Zephyr 文档、Kconfig 搜索、正则表达式资源 |
| [[04-Resources/Obsidian使用指南|Obsidian 使用指南]] | Vault 管理、插件推荐、同步方案 |

---

## 05-Questions 问题驱动

| 文件 | 问题 |
|------|------|
| [[05-Questions/驱动程序如何与硬件通信|驱动程序如何与硬件通信]] | Bindings → DTS → DT宏 → 寄存器的完整链条 |
| [[05-Questions/prjconf配置推导方法|prjconf 配置推导方法]] | 如何从零推导 prj.conf 和 app.overlay |

---

## Git Commit 规范

```bash
feat(concept):   新增 [概念名]
update(concept): 重构 [概念名]，补充 xxx
merge(concept):  合并 [文件A] 与 [文件B]
move:            迁移 [文件名] 至 [目标目录]
fix(concept):    修正 [概念名] 中的错误理解
link:            建立 [A] 与 [B] 的关联
test(project):   验证 [实验名称]
clean:           删除已整合旧稿
```

---

## 知识图谱关系速查

```
Zephyr
  ├── 构建链：West → CMake → Kconfig → DeviceTree → Ninja
  │           详见：[[Zephyr编译系统]]
  ├── 硬件抽象：DeviceTree + Overlay
  ├── 启动与驱动：[[Zephyr启动与设备初始化]]
  ├── 运行时：[[Thread]]
  └── 工程实践：[[Zephyr开发流程]]

STM32（待建设）
  └── 详见：[[03-Areas/STM32知识图谱]]
```
