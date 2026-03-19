# Zephyr RTOS 学习领域

> 长期关注方向 | 关联项目：[[02-Projects/30day-Zephyr/30天Zephyr工程师训练计划]]

## 当前状态

正在进行 30 天系统训练计划，目标：从 STM32 HAL 开发者成长为 Zephyr 嵌入式工程师。

---

## 核心知识地图

### 构建系统
- [[CMake]] — 构建系统生成器
- [[West]] — 多仓库管理工具
- [[Kconfig]] — 功能配置系统
- [[Zephyr编译系统]] — 四阶段构建流程

### 硬件抽象
- [[DeviceTree]] — 硬件描述语言
- [[Overlay]] — 应用级硬件配置补丁

### 系统核心
- [[Zephyr]] — 总览与架构
- [[Zephyr启动流程]] — 从复位到 main
- [[Zephyr开发流程]] — 标准五步开发法
- [[Thread]] — 线程与 RTOS 调度
- [[调用驱动函数硬件启动]] — 设备模型与自动初始化

### 工具
- [[QEMU]] — 虚拟仿真器

---

## 学习进度

- [x] 环境搭建与首次编译
- [x] CMake / Kconfig / DeviceTree 基础概念
- [x] Overlay 语法与开发流程
- [x] 多线程基础（Thread / Semaphore / Mutex）
- [ ] 驱动框架深入
- [ ] 子系统（蓝牙 / 网络 / 文件系统）
- [ ] 内核调度器机制

---

## 外部资源

- [Zephyr 官方文档](https://docs.zephyrproject.org/)
- [Kconfig 搜索](https://docs.zephyrproject.org/latest/kconfig.html)
- [[04-Resources/Zephyr-Git仓库使用说明]]
