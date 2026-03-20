# Zephyr 嵌入式知识库

从 STM32 HAL 转向 Zephyr RTOS 的学习记录，目标是找嵌入式工作。
用 Obsidian 管理笔记，Git 追踪认知变化。

---

## 正在进行

1. [[02-Projects/F103ZE/进度]]
2. [[02-Projects/QEMU/进度]]

---

## 这个仓库怎么用

| 发生了什么      | 做什么                                           | 快捷键            |
| ---------- | --------------------------------------------- | -------------- |
| 灵光一现，还没想清楚 | 丢进 `00-Inbox/`，文件名就是那个想法，内容可以只有一行             | `Ctrl+Shift+B` |
| 想清楚了，整理成问题 | 从 Inbox 移到 `05-Questions/`，补上猜测和拆解            | `Ctrl+Shift+Q` |
| 学了新概念      | 打开或新建 `01-Concepts/[概念名].md`，直接补充             | `Ctrl+Shift+C` |
| 做完一个实验demo | 新建 `02-Projects/F103ZE/实验/[实验名].md`，在进度.md 打勾 | `Ctrl+Shift+D` |
| 遇到报错或意外    | 回到对应 Concept 文件，补一条 `## 坑`                    | —              |

**完整流程：** `00-Inbox` → `05-Questions` → `01-Concepts`

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

## 仓库结构

```
00-Inbox/       灵光一现，随手捕获，不要求完整
01-Concepts/    知识原子，扁平存放，不建子文件夹
02-Projects/    按硬件平台分项目，每个项目结构一致
03-Areas/       领域导航，只做索引
04-Resources/   外部链接和参考资料
05-Questions/   整理后的问题，有猜测有拆解
_templates/     新建笔记时套用的模板
_manual/        仓库操作手册和配置备份
```
