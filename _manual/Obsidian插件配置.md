# Obsidian 插件配置记录

> 备份时间：2026-03 | 用途：换电脑或重装时快速恢复配置

---

## 已安装插件

| 插件 | 用途 |
|------|------|
| Templater | 新建笔记时自动套用模板结构 |
| QuickAdd | 一键创建带模板的笔记到指定目录 |

---

## Templater 配置

- Template folder location：`_templates`
- Trigger Templater on new file creation：开启

---

## QuickAdd 配置

三个 Template 类型的命令，配置如下：

| 命令名 | Template Path | Create in folder |
|--------|--------------|-----------------|
| New Question | `_templates/question.md` | `05-Questions` |
| New Concept | `_templates/concept.md` | `01-Concepts` |
| New Project | `_templates/project.md` | `02-Projects` |

**关键注意事项（踩过的坑）：**
- `File Name Format` 只填 `{{VALUE}}`，不要加路径
- `Create in folder` 不要加末尾斜杠
- `Folder Format` 输入框保持空白

---

## 快捷键绑定

| 命令 | 快捷键 |
|------|--------|
| QuickAdd: New Question | `Ctrl + Shift + Q` |
| QuickAdd: New Concept | `Ctrl + Shift + C` |
| QuickAdd: New Project | `Ctrl + Shift + P` |

---

## 模板文件位置

```
_templates/
├── question.md   → 问题驱动笔记模板
├── concept.md    → 原子化概念模板
└── project.md    → 实验验证模板
```
