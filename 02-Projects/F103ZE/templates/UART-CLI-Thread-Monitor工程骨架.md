# Zephyr + STM32F407 UART CLI + Thread Monitor 工程骨架

> 来源：00-Inbox 流转 2026-03-27，原存于 04-Resources，2026-03-28 迁移至此
> 类型：参考代码 / 项目模板
> 适用：STM32F407（stm32f4_disco），F103ZE 主线就绪后可参考迁移

---

## 项目结构

```bash
zephyr-runtime-inspector/
├── CMakeLists.txt
├── prj.conf
├── boards/
│   └── stm32f407vet6.overlay
├── src/
│   └── main.c
├── modules/
│   ├── cli/
│   ├── thread_monitor/
│   └── transport_uart/
└── include/
```

---

## prj.conf

```ini
CONFIG_MAIN_STACK_SIZE=2048
CONFIG_SERIAL=y
CONFIG_UART_CONSOLE=y
CONFIG_SHELL=y
CONFIG_SHELL_BACKEND_SERIAL=y
CONFIG_SHELL_STACK_SIZE=2048
CONFIG_THREAD_MONITOR=y
CONFIG_THREAD_NAME=y
CONFIG_INIT_STACKS=y
CONFIG_LOG=y
CONFIG_LOG_MODE_IMMEDIATE=y
```

---

## CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.20.0)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(runtime_inspector)

target_sources(app PRIVATE
    src/main.c
    modules/cli/cli.c
    modules/thread_monitor/thread_monitor.c
    modules/transport_uart/transport_uart.c
)
```

---

## main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(main);

void main(void)
{
    LOG_INF("Runtime Inspector Start");
    while (1) {
        k_sleep(K_SECONDS(5));
    }
}
```

---

## cli.c

```c
#include <zephyr/shell/shell.h>
#include "thread_monitor.h"

static int cmd_ps(const struct shell *shell, size_t argc, char **argv)
{
    ARG_UNUSED(argc);
    ARG_UNUSED(argv);
    thread_monitor_print(shell);
    return 0;
}

SHELL_CMD_REGISTER(ps, NULL, "Show thread info", cmd_ps);
```

---

## thread_monitor.c

```c
#include <zephyr/kernel.h>
#include <zephyr/shell/shell.h>
#include "thread_monitor.h"

static void thread_cb(const struct k_thread *thread, void *user_data)
{
    const struct shell *shell = user_data;
    const char *name = k_thread_name_get((k_tid_t)thread);
    size_t unused;
    k_thread_stack_space_get((k_tid_t)thread, &unused);
    shell_print(shell, "%-16s stack unused: %u",
                name ? name : "unknown", (uint32_t)unused);
}

void thread_monitor_print(const struct shell *shell)
{
    shell_print(shell, "Thread List:");
    shell_print(shell, "---------------------------");
    k_thread_foreach(thread_cb, (void *)shell);
}
```

---

## 编译与运行

```bash
west build -b stm32f4_disco .
west flash
```

---

## 预期输出

```bash
uart:~$ ps
Thread List:
---------------------------
main            stack unused: 1200
shell_uart      stack unused: 800
idle            stack unused: 256
```

---

## 可扩展方向

- 增加线程状态 + 优先级显示（`thread->base.prio` / `thread->base.thread_state`）
- CPU 占用统计（时间戳 + context switch hook 或 Zephyr tracing）
- `top` 命令实时刷新
- 串口 → Python → matplotlib 可视化
