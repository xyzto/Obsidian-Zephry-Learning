下面是 Obsidian Vault 管理的完整教程，涵盖文件组织、链接系统、插件生态等核心内容。

**Obsidian Vault** 本质上是一个本地文件夹，所有笔记以 `.md`（Markdown）格式存储，你完全拥有数据所有权。---

## 一、初始设置

**创建 Vault**：打开 Obsidian → "Create new vault" → 选择一个本地文件夹，名字随意（如 `My Notes`）。设置好后进入 Settings（齿轮图标）。

**推荐第一步设置**：

- `Files & Links → Default location for new notes`：改为 `In the folder specified below`，填入 `00-Inbox`
- `Files & Links → Attachment folder path`：填入 `Attachments`
- `Editor → Readable line length`：开启，阅读体验更好

---

## 二、文件夹结构（PARA 法则）

按上图的 PARA 结构建立文件夹，这是目前最流行的 Vault 组织方式：

**00-Inbox**：一切新想法、草稿、随手记的落脚点。每周定期清理，把成熟的内容移入对应区域。

**10-Areas**（领域）：长期持续维护的主题，比如"工作/健康/学习/个人成长"，没有截止日期。

**20-Resources**（资源）：外部参考资料、读书笔记、收藏的文章，按主题归类。

**30-Projects**（项目）：有明确目标和截止日期的事项，比如"2025年博客改版"，完成后归档到 `40-Archives`。

---

## 三、双向链接与笔记互联

双向链接是 Obsidian 最核心的功能，将孤立笔记变成知识网络：

- 输入 `[[` 即可搜索并链接已有笔记
- 链接不存在的笔记时，Obsidian 会自动创建占位页（ghost note）
- 用 `![[笔记名]]` 可以在当前页内嵌入另一条笔记的内容
- 在笔记底部的 "Backlinks" 面板可以看到所有反向链接

---

## 四、常用核心插件（内置）

进入 Settings → Core plugins 开启：

`Templates`：创建笔记模板，配合 `00-Templates` 文件夹，新建笔记时一键套用结构。

`Daily Notes`：每天自动创建日记，非常适合作为 Inbox 的子系统。

`Graph View`：以图谱形式可视化全部笔记之间的连接关系，可以过滤标签和文件夹。

`Starred`：收藏常用笔记或搜索，相当于书签。

---

## 五、推荐社区插件

进入 Settings → Community plugins → 关闭安全模式后可安装：

`Dataview`：用类 SQL 语法查询和展示笔记数据，比如列出所有带 `#todo` 标签的笔记并按日期排序，是笔记库的"动态报表"功能。

`Templater`：比内置 Templates 更强大，支持动态变量（如自动填入今天日期）和 JavaScript 脚本。

`Calendar`：在侧边栏显示日历，快速导航 Daily Notes。

`Kanban`：在 Vault 里创建看板，适合项目管理。

`Excalidraw`：在笔记中直接绘制手绘风格图表，并能双向链接其中的元素。

---

## 六、同步与备份

**免费方案**：将 Vault 放在 iCloud / Dropbox / OneDrive 文件夹内，跨设备自动同步。

**官方方案**：Obsidian Sync（收费），端对端加密，版本历史，最稳定。

**Git 备份**：配合 `obsidian-git` 插件，自动定期 commit 到私有仓库，既有版本历史又有云端备份，是技术用户最推荐的方案。

---

有哪个部分想深入了解？点击上方图中的模块可以展开具体问题，或者直接告诉我——比如 Dataview 的写法、Templater 的配置，或者 Daily Notes + GTD 工作流的搭建。