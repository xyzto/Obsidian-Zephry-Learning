# 知识库索引

> 创建于 2026-03 | 管理原则：原子化 · 可链接 · 可演化
> 领域：Zephyr RTOS 嵌入式开发 | 工具：Obsidian + Git

---

## 目录结构

```
E:\OB-Vaults\Zephry\
├── README.md              # 本文件，知识库总导航
├── _templates/            # 笔记模板（系统文件，非内容）
├── _维护/                 # 仓库维护手册（系统文件，非内容）
│
├── 00-Inbox/              # 输入缓冲：随手捕获，48h 内清空
├── 01-Concepts/           # 原子化概念库：一个文件只讲一件事
├── 02-Projects/           # 当前执行项目
├── 03-Areas/              # 长期关注领域
├── 04-Resources/          # 外部参考资料
└── 05-Questions/          # 问题驱动笔记（Concepts 的唯一入口）
```

**三条使用原则：**
- 新概念必须先在 `05-Questions` 提问，验证后才写入 `01-Concepts`
- 用 `[[链接]]` 建立概念关联，不用子文件夹做层级
- 随手捕获丢 `00-Inbox`，每周集中处理一次

---

## 01-Concepts 概念库

### Zephyr 系统核心

| 概念 | 一句话 |
|------|--------|
| [[Zephyr]] | 四大部件、五层架构、源码目录、排查思路 |
| [[Zephyr编译系统]] | 四阶段构建：配置合并→代码生成→编译→链接 |
| [[Zephyr启动与设备初始化]] | 从复位到 main，DEVICE_DT_DEFINE，设备自动初始化机制 |
| [[Zephyr开发流程]] | 标准五步法、Board Bring-up、四层推导框架 |

### 构建工具链

| 概念 | 一句话 |
|------|--------|
| [[CMake]] | 构建系统生成器，Make 是施工队，CMake 是建筑图 |
| [[West]] | 多仓库管理入口，常用命令，何时加 -p always |
| [[Kconfig]] | 功能开关系统，prj.conf 写法，menuconfig 搜索 |
| [[QEMU]] | 软件模拟 ARM，零硬件调试，局限性说明 |

### 硬件抽象层

| 概念 | 一句话 |
|------|--------|
| [[DeviceTree]] | 描述硬件的语言，节点/属性/compatible/DT宏 |
| [[Overlay]] | 应用级硬件补丁，五条语法规则，四步开发流程 |

### RTOS 运行时

| 概念 | 一句话 |
|------|--------|
| [[Thread]] | 线程本质、TCB、Zephyr API、信号量/互斥锁/队列 |

---

## 02-Projects 项目

### 30天 Zephyr 工程师训练计划

| 文件 | 说明 |
|------|------|
| [[02-Projects/30day-Zephyr/30天Zephyr工程师训练计划\|训练计划总览]] | 完整计划和阶段目标 |
| [[02-Projects/30day-Zephyr/基于F103改写\|基于F103改写]] | STM32F103 移植思路 |
| `日记/Day01 ～ Day30` | 每日学习记录 |

| 阶段 | 内容 |
|------|------|
| Day01-10 | 构建系统基础：CMake / Kconfig / DeviceTree / West |
| Day11-20 | 多线程：Thread / Semaphore / Mutex / Queue |
| Day21-30 | 驱动框架与子系统 |

---

## 03-Areas 长期领域

| 领域 | 说明 |
|------|------|
| [[03-Areas/Zephyr-RTOS\|Zephyr RTOS]] | 学习进度追踪、知识地图 |
| [[03-Areas/STM32知识图谱\|STM32 知识图谱]] | 建模目标、Concept 清单、问题列表、实验路线 |

---

## 04-Resources 参考资料

| 文件 | 说明 |
|------|------|
| [[04-Resources/Zephyr-Git仓库使用说明\|Zephyr Git 仓库]] | workspace 与 learning 仓库分离方案 |
| [[04-Resources/外部链接汇总\|外部链接汇总]] | Zephyr 文档、Kconfig 搜索、正则表达式资源 |
| [[04-Resources/硬件进阶路线\|硬件进阶路线]] | 芯片设计、边缘 AI、运动控制进阶方向 |
| [[04-Resources/开源项目推荐\|开源项目推荐]] | SimpleFOC / QMK / OpenAstroTracker 等 |
| [[04-Resources/Obsidian使用指南\|Obsidian 使用指南]] | Vault 管理、插件推荐、同步方案 |
| [[04-Resources/RT-Thread外链\|RT-Thread 外链]] | RT-Thread 官方 API 文档链接 |

---

## 05-Questions 问题驱动

| 问题 | 状态 |
|------|------|
| [[05-Questions/驱动程序如何与硬件通信\|驱动程序如何与硬件通信]] | ✅ 已验证 |
| [[05-Questions/prjconf配置推导方法\|如何从零推导 prj.conf 和 overlay]] | ✅ 已验证 |

---

## _维护 系统文件

| 文件 | 说明 |
|------|------|
| [[_维护/知识库维护手册\|知识库维护手册]] | 核心方法论：原子化、流程、模板、禁忌、自检清单 |
| [[_维护/Obsidian插件配置\|Obsidian 插件配置]] | Templater / QuickAdd 配置记录，换电脑时参考 |
| [[_维护/Obsidian使用指南\|Obsidian 使用指南]] | 双向链接、插件生态、同步方案 |

---

## Git Commit 规范

```bash
feat(concept):   新增 [概念名]
update(concept): 重构 [概念名]，补充 xxx
fix(concept):    修正 [概念名] 中的错误理解
link:            建立 [A] 与 [B] 的关联
merge(concept):  合并 [文件A] 与 [文件B]
move:            迁移 [文件名] 至 [目标目录]
test(project):   验证 [实验名称]
clean:           删除已整合旧稿
```

---

## 知识图谱速查

```
Zephyr
  ├── 构建链    West → CMake → Kconfig → DeviceTree → Ninja
  ├── 硬件抽象  DeviceTree + Overlay
  ├── 启动链    Zephyr启动与设备初始化
  ├── 运行时    Thread
  └── 工程实践  Zephyr开发流程

STM32（建设中）
  └── CPU → 总线 → 中断/DMA → USART/GPIO/定时器
  └── 详见 03-Areas/STM32知识图谱
```
