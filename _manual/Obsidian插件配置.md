# Obsidian 插件配置记录

> 备份时间：2026-03 | 用途：换电脑或重装时快速恢复配置

---

## 快速迁移到新电脑

直接复制整个 `.obsidian` 文件夹到新仓库，所有插件、快捷键、UI 设置全部一次性复制：

```powershell
Copy-Item -Path "E:\OB-Vaults\Zephry\.obsidian" -Destination "<新仓库路径>\.obsidian" -Recurse -Force
```

复制完在 Obsidian 里重新打开该 Vault 即可，无需手动重新配置任何东西。

---

## 隐藏系统文件夹

`_templates` 和 `_manual` 已通过 `app.json` 的 `userIgnoreFilters` 配置隐藏，不会显示在文件树里，但 Templater / QuickAdd 照常可以访问。

如需恢复显示：
```
Settings → Files & Links → Excluded files → 删除对应条目
```

---

## 附件存放位置（assets）

图片、PDF、音频等附件统一存放在 `assets/` 目录。

已在 `app.json` 配置，Obsidian 会自动把拖入的附件保存到这里，无需手动设置。

如需手动确认或修改：
```
Settings → Files & Links → Attachment folder path → assets
```

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

四个 Template 类型的命令，配置如下：

| 命令名 | Template Path | Create in folder |
|--------|--------------|-----------------|
| New Inbox | `_templates/Inbox.md` | `00-Inbox` |
| New Question | `_templates/Question.md` | `05-Questions` |
| New Concept | `_templates/Concept.md` | `01-Concepts` |
| New Project | `_templates/Project.md` | `02-Projects` |

**关键注意事项（踩过的坑）：**
- `File Name Format` 只填 `{{VALUE}}`，不要加路径
- `Create in folder` 不要加末尾斜杠
- `Folder Format` 输入框保持空白

---

## 快捷键绑定

| 命令 | 快捷键 |
|------|--------|
| QuickAdd: New Inbox | `Ctrl + Shift + I` |
| QuickAdd: New Question | `Ctrl + Shift + Q` |
| QuickAdd: New Concept | `Ctrl + Shift + C` |
| QuickAdd: New Project | `Ctrl + Shift + P` |

---

## 模板文件位置

```
_templates/
├── Inbox.md      → 随手捕获模板（灵光一现用）
├── Question.md   → 问题驱动笔记模板
├── Concept.md    → 原子化概念模板
└── Project.md    → 实验验证模板
```
