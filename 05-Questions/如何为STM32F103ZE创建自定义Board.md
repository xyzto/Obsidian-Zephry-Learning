# 如何为 STM32F103ZE 创建自定义 Zephyr Board？

> 来源：尝试把 Zephyr 跑在自己的 STM32F103ZE 板子上
> 状态：#进行中
> 关联概念：[[DeviceTree]] | [[Overlay]] | [[Zephyr开发流程]] | [[West]]

## 背景

`west boards | grep f103` 的结果：

```
gd32vf103c_starter   ← RISC-V，不是 STM32，忽略
gd32vf103v_eval      ← 同上
nucleo_f103rb        ← STM32F103RB，64引脚，最完整
stm32f103_mini       ← 最小系统板，最接近
```

Zephyr 没有直接支持 STM32F103ZE 的现成 Board，但 SoC 层完全支持。

## 核心判断

```
SoC（stm32f1）✅ 已支持 → 驱动、外设全部可用
Board（f103ze）❌ 没有  → 只需要自己写引脚描述
```

"Zephyr 不支持 F103ZE"是误区——它不提供现成 Board，不等于不支持芯片。

## F103ZE vs F103RB 的差异

| 型号 | Flash | RAM | 引脚 |
|------|-------|-----|------|
| F103RB（nucleo） | 128KB | 20KB | 64 |
| F103ZE（我的板） | 512KB | 64KB | 144 |

内核（Cortex-M3）完全一样，只是资源更多、IO 更多。

## 执行方案

### 方案 A：基于 stm32f103_mini 改写（推荐）

```bash
cp -r boards/others/stm32f103_mini boards/arm/my_f103ze
```

需要修改三处：

**1. 改型号名称**
```dts
model = "My STM32F103ZE Board";
```

**2. 改内存大小（关键）**
```dts
&flash0 {
    reg = <0x08000000 0x80000>;   /* 512KB */
};
&sram0 {
    reg = <0x20000000 0x10000>;   /* 64KB */
};
```

**3. 改外设（UART/LED 根据实际接线）**
```dts
&usart1 {
    status = "okay";
    current-speed = <115200>;
};
```

### 方案 B：先用 nucleo_f103rb 验证环境

```bash
west build -b nucleo_f103rb samples/basic/blinky
```

确认工具链没问题后再改 Board。

## 待确认信息

开始动手前需要确认：
- [ ] LED 接在哪个引脚？
- [ ] 串口用的是 USART1 还是 USART2？
- [ ] 是最小系统板还是自制 PCB？

## 关联
[[DeviceTree]] | [[Overlay]] | [[West]] | [[Zephyr开发流程]]
