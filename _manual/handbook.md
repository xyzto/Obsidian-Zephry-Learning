# 知识库维护手册

> 适用于任何学科的 Obsidian + Git 知识工程系统。
> 合并自原 handbook.md + structure.md + new-project-guide.md（2026-03-29）
>
> 当前仓库操作规则以 `_manual/ai/vault-prompt.md` 为准。格式规范见 `_manual/format-rules.md`。

---

## 一、核心理念

> **把笔记当成代码工程管理，而不是文档堆积。**

知识工程 = 问题驱动 + 结构化建模 + 实验验证 + 持续演化

三条黄金法则：

| 法则 | 含义 | 类比 |
|------|------|------|
| **原子化** | 一个文件只讲一件事 | 函数单一职责 |
| **可链接** | 用 `[[]]` 建立概念网络，不用子文件夹区分层级 | 模块依赖注入 |
| **可演化** | 每次理解升级就 git commit | 版本控制 |

---

## 二、目录结构与文件说明

```
knowledge-base/
├── README.md              # 知识库总索引
├── _templates/            # 笔记模板
├── _manual/               # 系统手册（本文件所在）
│   ├── ai/                # AI 运行时文件
│   ├── handbook.md        # 本文件
│   ├── format-rules.md    # 笔记格式规范
│   ├── git-guide.md       # Git 规范
│   └── obsidian-config.md # 插件配置备份
├── 00-Inbox/              # 捕获缓冲区，48h 内清空
├── 01-Concepts/           # 知识原子，扁平结构，禁止子文件夹
├── 02-Projects/           # 按平台/项目分文件夹
├── 03-Areas/              # 领域导航，只做索引
├── 04-Resources/          # 外部链接/索引，不放自己写的内容
├── 05-Questions/          # 结论待验证的问题
└── assets/                # 图片、附件
```

### 各区域角色

| 区域 | 角色 | 典型内容 |
|------|------|---------|
| 00-Inbox | 捕获缓冲 | 零碎想法、摘抄、疑问 |
| 01-Concepts | 知识原子 | `DMA.md` / `CMake.md` |
| 02-Projects | 执行单元 | 实验记录、训练计划 |
| 03-Areas | 领域导航 | 学习进度索引 |
| 04-Resources | 外部依赖 | 教材链接、工具手册 |
| 05-Questions | 问题引擎 | `为什么DMA比中断快.md` |

### `_manual/ai/` 文件说明

| 文件 | 用途 | 使用时机 |
|------|------|---------|
| `vault-prompt.md` | 仓库管理 AI 启动层提示词 | 每次开对话粘贴 |
| `rules-landing.md` | 实验落地专用规则 | 落地实验时追加粘贴 |
| `state.md` | 唯一状态文件（进度+待办+健康度） | 每次对话必读必写 |
| `study-prompt.md` | 学习 AI 提示词源文件 | 修改学习流程时编辑 |
| `study-context.md` | 学习 AI 完整上下文（自动维护） | 新开学习对话时粘贴 |
| `vault-root.md` | 根路径声明 | 换电脑时更新 |

### `02-Projects/<项目名>/` 子文件规范

```
02-Projects/<项目名>/
├── plan.md       # 阶段规划
├── progress.md   # 打勾记录，唯一进度来源
├── env.md        # 硬件引脚表、烧录方式、构建命令
└── lab/          # 每个实验一个文件，按编号命名
```

### `_templates/` 模板

| 模板 | 用途 | 快捷键 |
|------|------|--------|
| `Concept.md` | 新建概念 | Ctrl+Shift+C |
| `Question.md` | 新建问题 | Ctrl+Shift+Q |
| `Project.md` | 新建实验记录 | Ctrl+Shift+P |
| `Inbox.md` | 随手捕获 | Ctrl+Shift+I |

---

## 三、知识流转主流程

```
00-Inbox → 05-Questions → 01-Concepts
  捕获         提问            沉淀
```

| 触发 | 操作 |
|------|------|
| 遇到不懂的 | 丢进 Inbox，文件名即问题 |
| 整理 Inbox | 转化为 Questions，写下猜测 |
| 做实验/查资料 | 在 Projects 记录验证过程 |
| 理解成型 | 提炼写入 Concepts，建立链接 |
| 理解有变化 | git commit 记录认知升级 |

---

## 四、命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 英文概念 | 大驼峰或全大写缩写 | `CMake.md` / `DMA.md` |
| 中文概念 | 概念名本身 | `中断机制.md` |
| 问题文件 | 疑问句，动词开头 | `为什么DMA比中断快.md` |
| 项目文件夹 | 全大写型号或全小写描述 | `F103ZE/` / `QEMU/` |
| 禁止 | 序号、"未命名"、"总结" | ~~`1_笔记.md`~~ |

---

## 五、新建项目流程

### 方法一：让 AI 建

粘贴 vault-prompt.md 后追加：
```
我要新建项目 [项目名]，帮我在 02-Projects/ 下建好标准四文件结构。
```

### 方法二：PowerShell 脚本

```powershell
cd <VAULT_ROOT>\02-Projects
.\new-project.ps1 <项目名>
```

### 四个文件的内容规范

**plan.md**：阶段规划，参考已有项目格式。

**progress.md**：顶部注明"完整计划见 plan.md"，待做用 `- [ ]`，完成打勾 `- [x]`，不在其他文件重复记录。

**env.md**：真实硬件填引脚表、烧录方式、内存布局；QEMU 填常用目标板和启动命令。

**lab/**：文件名格式 `编号-实验名.md`，套用 `_templates/Project.md`。

---

## 六、系统三大禁忌

**禁忌 1：写总结文档**
❌ `STM32学习总结.md`
✅ `DMA.md` + `中断机制.md`（各自独立，相互链接）

**禁忌 2：用子文件夹替代链接**
❌ `01-Concepts/嵌入式/STM32/DMA.md`
✅ `01-Concepts/DMA.md`，文件内写 `[[STM32]]`

**禁忌 3：Inbox 堆积不清理**
超过 7 天未处理 → 系统开始失效。每周 30 分钟：Inbox → Questions → Concepts。

---

## 七、健康度自检（每月一次）

- [ ] Inbox 有超过 7 天未处理的文件？
- [ ] Concepts 有文件没有任何链接？
- [ ] Questions 有 #已验证 但未提炼为 Concept 的文件？
- [ ] README 的 Concepts 列表与实际文件是否同步？
- [ ] 最近一个月有 git commit 记录认知变化？

---

## 八、Git Commit 规范

```bash
feat(concept):   新增 [概念名]
update(concept): 补充/重构 [概念名]
fix(concept):    修正错误理解
link:            建立概念关联
test(project):   完成实验 [实验名]
merge:           合并文件
move:            迁移文件
rename:          重命名
clean:           删除旧稿
update(manual):  更新系统文件
```

---

## 九、快速初始化新仓库

**Bash**
```bash
name="my-knowledge-base"
mkdir -p $name/{00-Inbox,01-Concepts,02-Projects,03-Areas,04-Resources,05-Questions,assets,_templates,_manual/ai}
cd $name && git init
echo ".obsidian/" > .gitignore
touch README.md
git add . && git commit -m "init: 建立知识库基础结构"
```

**PowerShell**
```powershell
$name = "my-knowledge-base"
$dirs = "00-Inbox","01-Concepts","02-Projects","03-Areas","04-Resources","05-Questions","assets","_templates","_manual\ai"
New-Item -ItemType Directory -Path $name
$dirs | ForEach-Object { New-Item -ItemType Directory -Path "$name\$_" }
Set-Location $name && git init
".obsidian/" | Out-File .gitignore -Encoding utf8
New-Item README.md
git add . && git commit -m "init: 建立知识库基础结构"
```

---

## 十、适用学科示例

| 学科 | 典型 Concept | 典型 Question | 典型 Project |
|------|-------------|--------------|-------------|
| 嵌入式 | `DMA.md` | `为什么DMA比中断快.md` | `USART+DMA接收实验` |
| 数学 | `极限.md` | `epsilon-delta为什么这么定义.md` | `高数期末复习` |
| 编程 | `闭包.md` | `JS为什么是单线程.md` | `实现一个Promise` |
| 历史 | `民族主义.md` | `一战为什么在萨拉热窝爆发.md` | `二战起因对比分析` |
