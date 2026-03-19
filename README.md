# Zephyr 嵌入式知识库

从 STM32 HAL 开发者成长为 Zephyr 工程师的学习记录。
原则：**学完直接写 Concept，遇到问题直接建 Question，不做中间层。**

---

## 现在在哪里

→ [[02-Projects/30day-Zephyr/进度]]

---

## 怎么用这个库

**学到新概念** → `Ctrl+Shift+C` 新建 Concept，或打开已有文件直接补充

**遇到不懂的** → `Ctrl+Shift+Q` 新建 Question，写下猜测和拆解，搞懂后填结论

**没有日记，没有中转，两步完成**

---

## 从哪里开始看

理解 Zephyr 是什么 → [[Zephyr]]

理解整个构建过程 → [[Zephyr编译系统]]

写第一个项目 → [[Zephyr开发流程]]

遇到问题 → [[05-Questions/驱动程序如何与硬件通信]] / [[05-Questions/prjconf配置推导方法]]

---

## 知识地图

```
Zephyr
  ├── 构建链   West → CMake → Kconfig → DeviceTree → Ninja
  ├── 硬件     DeviceTree → Overlay
  ├── 启动     Zephyr启动与设备初始化
  ├── 运行     Thread（信号量 / Mutex / 消息队列）
  └── 实践     Zephyr开发流程

STM32（规划中）→ [[03-Areas/STM32知识图谱]]
```

---

<details>
<summary>完整索引（点击展开，不需要每次更新）</summary>

**01-Concepts**

| 概念 | 内容 |
|------|------|
| [[Zephyr]] | 四大部件、五层架构、源码目录 |
| [[Zephyr编译系统]] | 四阶段构建流程 |
| [[Zephyr启动与设备初始化]] | 复位→main，设备自动初始化 |
| [[Zephyr开发流程]] | 五步法、Board Bring-up |
| [[CMake]] | 构建系统生成器原理 |
| [[West]] | 多仓库管理，常用命令 |
| [[Kconfig]] | 功能开关，prj.conf 写法 |
| [[QEMU]] | 软件模拟 ARM，零硬件调试 |
| [[DeviceTree]] | 硬件描述语言，DT 宏 |
| [[Overlay]] | 应用级硬件补丁，五条语法规则 |
| [[Thread]] | 线程 API，信号量/Mutex/消息队列 |

> 新增 Concept 后不需要更新这张表。这里只列重要的导航入口，不求完整。

**04-Resources**

| 文件 | 内容 |
|------|------|
| [[04-Resources/外部链接汇总\|外部链接]] | Zephyr 文档、Kconfig 搜索、推荐开发板 |
| [[04-Resources/进阶方向\|进阶方向]] | 开源项目参考、芯片设计、边缘AI、运动控制 |

**05-Questions**

| 问题 | 状态 |
|------|------|
| [[05-Questions/驱动程序如何与硬件通信]] | ✅ |
| [[05-Questions/prjconf配置推导方法]] | ✅ |
| [[05-Questions/线程调度相关问题集]] | ✅ |
| [[05-Questions/Zephyr开发是不是伪命题]] | ✅ |
| [[05-Questions/如何为STM32F103ZE创建自定义Board]] | 🔲 进行中 |

> 新增 Question 后不需要更新这张表。Questions 本身就是导航。

**_维护**

| 文件 | 内容 |
|------|------|
| [[_维护/知识库维护手册\|维护手册]] | 核心方法论、流程规则、模板、禁忌 |
| [[_维护/Obsidian插件配置\|插件配置]] | Templater / QuickAdd 配置，换电脑时参考 |
| [[_维护/Zephyr-Git仓库使用说明\|Git 仓库方案]] | workspace 与 learning 仓库分离方案 |
| [[_维护/AI协作提示词\|AI 协作提示词]] | 开启新对话时粘贴给 AI，快速上手管理仓库 |

</details>
