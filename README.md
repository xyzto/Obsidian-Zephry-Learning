# Zephyr 嵌入式知识库

从 STM32 HAL 转向 Zephyr RTOS 的学习记录，目标是找嵌入式工作。
用 Obsidian 管理笔记，Git 追踪认知变化。

---

## 正在进行

1. [[02-Projects/F103ZE/progress]]
2. [[02-Projects/QEMU/progress]]

---

## 这个仓库怎么用

| 发生了什么 | 做什么 | 快捷键 |
|-----------|--------|--------|
| 灵光一现，还没想清楚 | 丢进 `00-Inbox/`，文件名就是那个想法，内容可以只有一行 | `Ctrl+Shift+I` |
| 想清楚了，整理成问题 | 从 Inbox 移到 `05-Questions/`，补上猜测和拆解 | `Ctrl+Shift+Q` |
| 学了新概念 | 打开或新建 `01-Concepts/[概念名].md`，直接补充 | `Ctrl+Shift+C` |
| 做完一个实验 | 在对应项目的 `lab/` 目录里新建一个文件，在 progress.md 打勾 | — |
| 遇到报错或意外 | 回到对应 Concept 文件，补一条 `## 坑` | — |

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

→ [[_manual/structure]]

```
00-Inbox/       随手捕获，灵光一现
01-Concepts/    知识原子，扁平存放
02-Projects/    按平台分项目
03-Areas/       领域导航
04-Resources/   外部链接和参考资料
05-Questions/   整理后的问题
_templates/     笔记模板
_manual/        操作手册和配置备份
```
