# Zephyr 初始化为什么不需要手动调用外设 Init？

> 来源：00-Inbox 捕获 2026-03-20
> 状态：#未解决
> 关联概念：[[01-Concepts/Zephyr启动与设备初始化]] | [[01-Concepts/DeviceTree]]

## 当前猜测

Zephyr 在启动阶段有一套自动初始化机制，设备驱动通过宏注册初始化函数，内核在 `main()` 之前按优先级依次调用，不需要用户手动触发。

## 拆解
- HAL 里 `MX_GPIO_Init()` 是用户在 `main.c` 显式调用的
- Zephyr 里串口能在 `main()` 开始前就工作，说明初始化发生在更早的阶段
- 关键宏可能是 `SYS_INIT` 或 `DEVICE_DT_DEFINE` 中的 init 回调

## 验证方式
- [ ] 查看 `kernel/init.c`，找 `z_sys_init_run_level` 或类似函数
- [ ] 搜索 UART 驱动里的 `SYS_INIT` 或 `DEVICE_DT_DEFINE` 调用
- [ ] 对照实验 14（驱动模型阅读）的结论

## 结论

## 关联
[[01-Concepts/Zephyr启动与设备初始化]]
