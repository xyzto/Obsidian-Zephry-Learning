# Zephyr 嵌入式知识库

从 STM32 HAL 开发者成长为 Zephyr 工程师的学习记录。
以 Obsidian + Git 管理，原则：**一个文件只讲一件事，链接代替层级，每次理解升级就 commit。**

---

## 现在在哪里

30 天训练计划进行中，目前完成到：

- [x] 构建系统基础：[[CMake]] / [[Kconfig]] / [[DeviceTree]] / [[West]]
- [x] 硬件抽象：[[Overlay]] 语法与开发流程
- [x] 多线程：[[Thread]]，信号量 / 互斥锁 / 队列
- [ ] **驱动框架深入** ← 当前位置
- [ ] 子系统：蓝牙 / 网络 / 文件系统
- [ ] 内核调度器机制

详细进度见 [[03-Areas/Zephyr-RTOS]]，训练计划见 [[02-Projects/30day-Zephyr/30天Zephyr工程师训练计划]]。

---

## 从哪里开始看

**理解 Zephyr 是什么** → [[Zephyr]]

**理解整个构建过程** → [[Zephyr编译系统]]

**写第一个项目** → [[Zephyr开发流程]]

**卡在某个问题** → [[05-Questions/驱动程序如何与硬件通信]] / [[05-Questions/prjconf配置推导方法]]

---

## 知识地图

```
Zephyr
  ├── 构建链   West → CMake → Kconfig → DeviceTree → Ninja
  ├── 硬件     DeviceTree → Overlay
  ├── 启动     Zephyr启动与设备初始化
  ├── 运行     Thread
  └── 实践     Zephyr开发流程

STM32（规划中）
  └── CPU → 总线 → 中断/DMA → USART/GPIO/定时器
  └── 见 [[03-Areas/STM32知识图谱]]
```

---

## 完整索引

<details>
<summary>01-Concepts 概念库（点击展开）</summary>

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
| [[Thread]] | 线程 API，信号量/互斥锁/队列 |

</details>

<details>
<summary>04-Resources 参考资料（点击展开）</summary>

| 文件 | 说明 |
|------|------|
| [[04-Resources/Zephyr-Git仓库使用说明\|Git 仓库方案]] | workspace 与 learning 分离 |
| [[04-Resources/外部链接汇总\|外部链接]] | Zephyr 文档、Kconfig 搜索 |
| [[04-Resources/硬件进阶路线\|硬件进阶路线]] | 芯片设计、边缘 AI、运动控制 |
| [[04-Resources/开源项目推荐\|开源项目]] | SimpleFOC / QMK 等 |
| [[04-Resources/Obsidian使用指南\|Obsidian 指南]] | 插件、同步、双向链接 |

</details>

<details>
<summary>_维护 系统文件（点击展开）</summary>

| 文件 | 说明 |
|------|------|
| [[_维护/知识库维护手册\|维护手册]] | 方法论、模板、禁忌、自检清单 |
| [[_维护/Obsidian插件配置\|插件配置]] | Templater / QuickAdd 配置记录 |

</details>

---

## Git Commit 规范

```
feat(concept):   新增概念
update(concept): 补充/重构概念
fix(concept):    修正错误理解
link:            建立概念关联
test(project):   验证实验
clean:           删除旧稿
```
