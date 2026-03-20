# New Project Guide — 新建项目说明

> 用途：新增开发板或实验平台时，保证每个项目文件夹结构一致
> 相关脚本：`02-Projects/new-project.ps1`

---

## 标准目录结构

每个项目文件夹必须包含以下四个部分，缺一不可：

```
02-Projects/<项目名>/
├── plan.md       # 该项目的阶段规划和每日任务（学习计划）
├── progress.md   # 打勾记录，当前位置，唯一进度来源
├── env.md        # 硬件引脚表、烧录方式、构建命令（环境信息）
└── lab/          # 每个实验一个文件，按编号命名
    ├── 01-board-bringup.md
    ├── 02-gpio-interrupt.md
    └── ...
```

---

## 方法一：PowerShell 脚本（推荐）

进入 `02-Projects/` 目录后运行：

```powershell
cd E:\OB-Vaults\Zephry\02-Projects
.\new-project.ps1 <项目名>
```

示例：

```powershell
.\new-project.ps1 nRF52840
.\new-project.ps1 ESP32C3
.\new-project.ps1 QEMU-BLE
```

脚本会自动建好目录和四个文件，内容留空待填。

---

## 方法二：让 AI 来建

新对话里粘贴 [[_manual/ai-prompt]] 后追加：

```
我新买了一块 [板子名] 开发板，帮我在 02-Projects/ 下新建一个项目文件夹，
按标准四文件结构，环境信息里的硬件参数我来填。
```

---

## 四个文件的内容规范

### plan.md（学习计划）
写该项目的阶段规划，参考 [[02-Projects/F103ZE/plan]] 的格式。

### progress.md（进度）
- 顶部注明"完整计划见：[[02-Projects/项目名/plan]]"
- 待做项用 `- [ ]`，完成后打勾 `- [x]`
- 不要在其他文件重复记录进度

### env.md（环境信息）
- 真实硬件：填写引脚表、烧录方式、内存布局
- 仿真平台（QEMU）：记录常用目标板和启动命令，无需引脚表

### lab/（实验目录）
- 文件名格式：`编号-实验名称.md`，如 `01-board-bringup.md`
- 每个实验记录：目标、源码、运行命令、现象、坑、结论、疑问与解答

---

## 实验记录模板

新建实验文件时套用 [[_templates/Project]] 模板。
