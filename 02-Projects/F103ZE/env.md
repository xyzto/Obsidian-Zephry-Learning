# 环境信息 — STM32F103ZE

> 板子类型：自制板
> 芯片：STM32F103ZE（Cortex-M3，512KB Flash，64KB RAM，144引脚）
> Zephyr Board 名称：my_f103ze（待创建）

---

## 引脚表（待填写）

查原理图后填入：

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
| SPI CS |    |         |      |

---

## 烧录方式

- 接口：SWD / JTAG（待确认）
- 工具：ST-Link / J-Link（待确认）
- west flash 命令：

```bash
west flash --runner openocd
# 或
west flash --runner jlink
```

---

## 内存布局

```dts
&flash0 {
    reg = <0x08000000 0x80000>;   /* 512KB */
};
&sram0 {
    reg = <0x20000000 0x10000>;   /* 64KB */
};
```

---

## 常用构建命令

```bash
# 首次构建
west build -b my_f103ze samples/basic/blinky

# 强制清理重编（改了 overlay 或 board 配置后必用）
west build -p always -b my_f103ze <app路径>

# 烧录
west flash

# 查看内存占用
west build -t ram_report
west build -t rom_report
```

---

## 参考

- Board 创建过程 → [[05-Questions/如何为STM32F103ZE创建自定义Board]]
- 相关 Concepts → [[DeviceTree]] | [[Overlay]] | [[West]]
