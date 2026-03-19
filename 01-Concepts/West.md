
在 Zephyr 开发中，`west` 不仅仅是一个构建工具，它是整个生态系统的“瑞士军刀”。按照 RTOS 学习的正常顺序，掌握这几个核心指令能让你在后续实验中事半功倍。

---

## 🛠️ West 四大核心命令

### 1. `west build` (编译)

这是你用得最频繁的命令。

- **常用用法**：`west build -b qemu_cortex_m3`
    
    - `-b` 代表 **Board**（目标板）。
        
- **进阶用法**：`west build -p always`
    
    - `-p` 代表 **Pristine**（纯净）。它会在编译前自动删除旧的编译缓存，相当于手动执行了 `rm -rf build`。**当你移动了文件夹或修改了重要的 Kconfig 后，请务必带上这个参数。**
        
- **指定目录**：`west build -d my_build_dir`
    
    - 如果你想把编译产物放在特定的文件夹（而不是默认的 `build`），可以用这个。
        

### 2. `west flash` (烧录)

虽然我们现在在用 QEMU，但当你拿到真实的开发板（如 STM32 或 ESP32）时，这个命令会将编译好的 `.bin` 或 `.hex` 文件写入芯片。

- **用法**：`west flash`
    
    - 它会自动调用底层的 OpenOCD 或 J-Link 工具。
        

### 3. `west run` 或 `west build -t run` (仿真运行)

这是专门给 QEMU 准备的命令。

- **用法**：`west build -t run`
    
    - `-t` 代表 **Target**（目标）。这会启动 QEMU 并在你的终端显示输出。
        
    - **退出方法**：`Ctrl + A` 然后按 `X`。
        

### 4. `west config` (配置查询)

如果你想知道当前的 Zephyr 路径设置在哪里。

- **用法**：`west config -l`
    
    - 它会列出所有当前生效的环境变量和路径。
        

---

## 🔍 实用小技巧：查看配置 (Guiconfig)

这是专业工程师最喜欢的“隐藏功能”。当你对 `prj.conf` 里的配置项感到头晕时，运行：

Bash

```
west build -t guiconfig
```

它会弹出一个图形化界面，让你像在 Windows 里点选设置一样，搜索并开启/关闭内核功能（比如开启多线程监控、调节日志级别等）。修改后保存，它会自动同步到你的编译配置中。

---


