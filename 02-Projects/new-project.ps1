# new-project.ps1
# 用途：在 02-Projects/ 下新建标准项目文件夹
# 用法：.\new-project.ps1 <项目名>
# 示例：.\new-project.ps1 nRF52840

param([string]$name)

if (-not $name) {
    Write-Host "用法：.\new-project.ps1 <项目名>"
    Write-Host "示例：.\new-project.ps1 nRF52840"
    exit
}

$base = "E:\OB-Vaults\Zephry\02-Projects\$name"

if (Test-Path $base) {
    Write-Host "❌ 项目已存在：$base"
    exit
}

# 建目录
New-Item -ItemType Directory -Path "$base\lab" -Force | Out-Null

# plan.md（学习计划）
@"
# Plan — $name

> 目标：
> 硬件：
> 投入：

## 阶段规划

### 第一阶段：

### 第二阶段：

### 第三阶段：
"@ | Out-File "$base\plan.md" -Encoding utf8

# progress.md（进度）
@"
# Progress — $name

> 完整计划见：[[02-Projects/$name/plan]]

## 当前位置：

## 待做

- [ ]

## 已完成
"@ | Out-File "$base\progress.md" -Encoding utf8

# env.md（环境信息）
@"
# Env — $name

> 板子类型：
> 芯片：
> Zephyr Board 名称：

## 引脚表

| 外设 | 引脚 | 有效电平 | 备注 |
|------|------|---------|------|
| LED  |      |         |      |
| 按键  |      |         |      |
| USART TX |  |         |      |
| USART RX |  |         |      |
| SWD CLK |   |         |      |
| SWD DIO |   |         |      |
| I2C SDA |   |         |      |
| I2C SCL |   |         |      |
| SPI MOSI |  |         |      |
| SPI MISO |  |         |      |
| SPI SCK |   |         |      |
| SPI CS  |   |         |      |

## 烧录方式

- 接口：（待确认）
- 工具：（待确认）

\`\`\`bash
west flash --runner openocd
# 或
west flash --runner jlink
\`\`\`

## 内存布局

\`\`\`dts
&flash0 {
    reg = <0x???????? 0x?????>;
};
&sram0 {
    reg = <0x20000000 0x?????>;
};
\`\`\`

## 常用构建命令

\`\`\`bash
# 首次构建
west build -b <board> <app路径>

# 强制清理重编
west build -p always -b <board> <app路径>

# 烧录
west flash

# 查看内存占用
west build -t ram_report
west build -t rom_report
\`\`\`
"@ | Out-File "$base\env.md" -Encoding utf8

# 保留空的 lab 目录
New-Item "$base\lab\.gitkeep" -Force | Out-Null

Write-Host "✅ 项目已创建：$base"
Write-Host ""
Write-Host "接下来："
Write-Host "  1. 打开 $base\env.md，填写引脚表"
Write-Host "  2. 打开 $base\plan.md，写阶段规划"
Write-Host "  3. git add -A && git commit -m `"feat: 新建项目 $name`""
