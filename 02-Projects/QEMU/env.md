# 环境信息 — QEMU

> QEMU 是软件模拟器，无需真实硬件，无引脚表

---

## 常用目标板与启动命令

```bash
# Cortex-M3（最常用，最接近 STM32）
west build -b qemu_cortex_m3 <app路径>
west build -t run

# native_sim（最快，适合纯逻辑测试）
west build -b native_sim <app路径>
west build -t run

# 退出 QEMU
Ctrl + A → 然后按 X
```

---

## 调试命令

```bash
# 启动 GDB 调试
west build -t debug

# 查看配置是否生效
west build -t menuconfig

# 查看内存占用
west build -t ram_report
```

---

## QEMU 与真实硬件的差异

| 方面 | QEMU | 真实硬件 |
|------|------|---------|
| 外设支持 | 有限（UART、定时器、基础外设） | 完整 |
| 时序精度 | 不准确 | 准确 |
| 中断响应时间 | 不可测量 | 可测量 |
| 适合场景 | 逻辑验证、API 学习 | 完整功能验证 |

---

## 参考

→ [[01-Concepts/QEMU]]
