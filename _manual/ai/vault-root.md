# Vault Root — 仓库根路径

> 换电脑或迁移仓库时，只需修改这一个文件。
> 所有 AI 提示词和脚本均通过读取本文件获取根路径，不在其他地方硬编码绝对路径。

---

## 根路径

```
E:\OB-Vaults\Zephry
```

---

## 使用方法（AI）

AI 收到提示词后第一步读取本文件，将上方路径赋值为 `VAULT_ROOT`，后续所有路径按如下规则拼接：

```
完整路径 = VAULT_ROOT + \ + 相对路径
```

示例：
- `_manual\session-log.md`   →  `E:\OB-Vaults\Zephry\_manual\session-log.md`
- `02-Projects\QEMU\lab\`   →  `E:\OB-Vaults\Zephry\02-Projects\QEMU\lab\`

## 使用方法（PowerShell 脚本）

```powershell
$VAULT_ROOT = Get-Content "$PSScriptRoot\..\vault-root.md" | Select-String '^\S' | Select-Object -First 1
cd "$VAULT_ROOT\02-Projects"
```
