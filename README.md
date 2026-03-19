# Zephyr 嵌入式知识库

这是我从 STM32 HAL 转向 Zephyr RTOS 的学习记录，目标是找嵌入式相关工作。

用 Obsidian 管理笔记，Git 追踪认知变化。核心原则是**学完直接写进 Concept，遇到问题直接建 Question，不做日记中转**。

---

## 现在在哪里

- 真实硬件（STM32F103ZE）→ [[02-Projects/F103ZE/进度]]
- 仿真实验（QEMU）→ [[02-Projects/QEMU/进度]]

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

## 使用规则

| 场景 | 操作 |
|------|------|
| 学了新概念 | `Ctrl+Shift+C` 新建或打开已有 Concept 直接补充 |
| 遇到不懂的 | `Ctrl+Shift+Q` 新建 Question，先写猜测，搞懂后填结论 |
| 做完实验 | 在对应项目的 `实验/` 目录里新建一个文件 |
| 遇到报错或意外行为 | 回到对应 Concept 文件，补一条 `## 坑` |

---

## 仓库结构

```
01-Concepts/    知识原子，扁平存放，不建子文件夹
02-Projects/    按硬件平台分项目，每个项目结构一致
03-Areas/       领域导航，只做索引
04-Resources/   外部链接和参考资料
05-Questions/   问题驱动笔记
_templates/     新建笔记时套用的模板
_manual/        仓库操作手册和配置备份
```
