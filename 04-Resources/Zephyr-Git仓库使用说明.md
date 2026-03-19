# Zephyr Git 仓库使用说明

> 类型：操作指南 | 场景：workspace 与 learning 仓库分离管理

## 核心方案：符号链接

在 `zephyr-workspace` 中创建符号链接指向 `zephyr-learning/app`，开发时修改的是同一份代码，git 操作在 `zephyr-learning` 里执行。

## 具体步骤

```bash
# 进入工作区
cd ~/projects/zephyr-workspace

# 创建符号链接（dev_app 指向 learning 仓库的 app 目录）
ln -s ~/projects/zephyr-learning/app dev_app

# 验证
ls -l dev_app
# 应显示：dev_app -> /home/yu/projects/zephyr-learning/app
```

## 日常开发流程

```bash
# 1. 在 workspace 里编译（产物在 workspace/build，不污染 learning）
west build -b <board> dev_app

# 2. 修改代码后，去 learning 仓库提交
cd ~/projects/zephyr-learning
git add app/
git commit -m "feat: xxx"
git push
```

## 注意事项

- **永远不要**在 `zephyr-workspace` 里执行 `git init`，否则会把几十 GB 的 Zephyr 源码纳入版本控制
- `build/` 目录已在 `.gitignore` 里，无需手动处理
- 符号链接在 Docker 容器内同样有效（路径基于宿主机绝对路径）

## west.yml 版本同步

`zephyr-learning` 里的 `west.yml` 需要与 `zephyr-workspace` 使用的 Zephyr 版本一致。升级 Zephyr 版本时：

```bash
# 1. 在 workspace 里更新
west update

# 2. 同步 west.yml 到 learning 仓库
cp zephyr/west.yml ~/projects/zephyr-learning/
cd ~/projects/zephyr-learning
git add west.yml
git commit -m "chore: 同步 Zephyr 版本"
```
