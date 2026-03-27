# Vault Root — 仓库根路径

> 换电脑或迁移仓库时，只需修改这一个文件。

---

## 根路径

```
E:\OB-Vaults\Zephry
```

---

## 适用场景说明

### MCP 环境（Claude + obsidian-notes-mcp）

**AI 无需读取本文件。** MCP 工具使用 vault 内相对路径，直接操作，无需拼接根路径。
本文件在 MCP 环境下不参与 AI 启动流程。

### 手动 / 脚本场景

换电脑或迁移仓库时，修改上方根路径，PowerShell 脚本从此处读取：

```powershell
$VAULT_ROOT = Get-Content "$PSScriptRoot\..\vault-root.md" | Select-String '^\S' | Select-Object -First 1
cd "$VAULT_ROOT\02-Projects"
```

示例路径拼接：
- `_manual\session-log.md`   →  `E:\OB-Vaults\Zephry\_manual\session-log.md`
- `02-Projects\QEMU\lab\`   →  `E:\OB-Vaults\Zephry\02-Projects\QEMU\lab\`
