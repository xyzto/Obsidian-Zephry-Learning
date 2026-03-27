# 什么是 Zephyr 子系统？

在 Zephyr RTOS 的世界里，**子系统（Subsystems）** 是位于内核（Kernel）之上、应用层（Application）之下的**中间件层**。

如果把内核比作操作系统的"心脏"（负责心跳、呼吸、血液循环），那么子系统就是"功能器官"（如视觉、听觉、消化系统），它们为特定的应用需求提供标准化的功能。

---

## 架构位置

Zephyr 的架构高度模块化。子系统通常是一组与硬件无关（Hardware-independent）的代码库，它们封装了复杂的协议或功能，通过标准的 API 与内核通信。

---

## 常见子系统

- **网络栈 (Networking)**：完整的 TCP/IP 协议栈，支持 IPv4/IPv6、MQTT、HTTP、CoAP 等。
- **蓝牙 (Bluetooth)**：业界领先的开源蓝牙协议栈（BLE 和经典蓝牙），支持多种 Profile。
- **存储与文件系统 (Storage & File Systems)**：如 LittleFS、NVS（非易失性存储），用于处理 Flash 上的数据掉电保存。
- **设备管理 (Device Management)**：包含 LwM2M 或固件空中升级（MCUmgr/DFU）。
- **日志系统 (Logging)**：统一的 `LOG_INF`、`LOG_ERR` 输出机制，支持多后端（UART、RTT、网络）。
- **电源管理 (Power Management)**：自动处理休眠、唤醒和外设低功耗状态。

---

## 对开发者的意义

### 1. 避免重复造轮子

需要联网或 OTA 升级时，只需在 `prj.conf` 中开启对应子系统（如 `CONFIG_BT=y`），直接调用标准 API 即可。

### 2. 代码可移植性

子系统屏蔽底层硬件差异。无论在 QEMU 还是真实 Cortex-M4 上，调用的网络 API 或文件系统 API 完全一致。

### 3. 与驱动层的关系

驱动开发属于 **Device Driver** 层，子系统是其上一层。典型串联方式：

- 触发 GPIO 中断 → 通过 **Logging 子系统** 记录日志
- 触发 GPIO 中断 → 通过 **Settings 子系统** 将触发次数保存到 Flash

---

## 快速启用示例

在 `prj.conf` 中添加：

```
CONFIG_LOG=y
CONFIG_SHELL=y
```

包含头文件 `<zephyr/logging/log.h>` 后即可在终端通过命令行查看系统状态，无需手写串口交互逻辑。
