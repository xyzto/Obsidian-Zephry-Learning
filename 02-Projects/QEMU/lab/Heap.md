# 实验 09：动态内存分配 (k_mem_slab / k_heap)

> 日期：2026-03-22
> 目标板：qemu_cortex_m3
> 关联 Concept：[[01-Concepts/k_mem_slab]] | [[01-Concepts/k_heap]] | [[01-Concepts/MemoryManagement]]

## 目标

验证 Zephyr 中两种动态内存分配方式：固定块 slab（高效、无碎片）和可变大小 heap（灵活、易碎片），理解内存泄漏、碎片与栈/堆的本质区别。

---

## 关键机制

**k_mem_slab**：预切分等大固定块，分配/释放走链表头操作，O(1) 时间，不产生碎片；代价是所有块尺寸必须一致。

**k_heap**：基于 `sys_heap` 支持可变大小，但频繁分配/释放不同大小的块会留下"空洞"，导致剩余总量够用却无法分配连续块。

**碎片的代价**：嵌入式系统 RAM 有限、长期运行，碎片积累导致分配失败；分配时间不确定则破坏实时响应。

**选用原则**：静态分配优先，其次 slab，最后 heap——这是嵌入式内存管理的基本铁律。

---

## 源码位置

→ 源码路径：`kernel/mem_slab.c`、`lib/os/heap.c`
→ 关键函数：`z_impl_k_mem_slab_alloc()`、`k_heap_alloc()`、`sys_heap_alloc()`

---

## 源码

### main.c

```c
#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

#define BLOCK_SIZE 64
#define NUM_BLOCKS 8

K_MEM_SLAB_DEFINE(my_slab, BLOCK_SIZE, NUM_BLOCKS, 4);

K_HEAP_DEFINE(my_heap, 1024);

void test_mem_slab(void)
{
    void *blocks[NUM_BLOCKS] = {0};
    int i;

    printk("测试内存 slab (固定块):\n");
    for (i = 0; i < NUM_BLOCKS; i++) {
        void *mem;
        int ret = k_mem_slab_alloc(&my_slab, &mem, K_NO_WAIT);
        if (ret == 0) {
            blocks[i] = mem;
            printk("分配块 %d: %p\n", i, blocks[i]);
        } else {
            printk("块 %d 分配失败（池满）\n", i);
            break;
        }
    }

    for (i = 0; i < NUM_BLOCKS / 2; i++) {
        if (blocks[i]) {
            k_mem_slab_free(&my_slab, &blocks[i]);
            printk("释放块 %d\n", i);
        }
    }

    void *extra;
    int ret_extra = k_mem_slab_alloc(&my_slab, &extra, K_NO_WAIT);
    printk("额外分配: %p %s\n", extra, (ret_extra == 0) ? "(成功)" : "(失败)");
}

void test_heap(void)
{
    printk("\n测试 k_heap (可变大小):\n");
    void *p1 = k_heap_alloc(&my_heap, 128, K_NO_WAIT);
    void *p2 = k_heap_alloc(&my_heap, 256, K_NO_WAIT);
    void *p3 = k_heap_alloc(&my_heap, 512, K_NO_WAIT);

    printk("128B: %p\n", p1);
    printk("256B: %p\n", p2);
    printk("512B: %p\n", p3);

    if (p2) {
        k_heap_free(&my_heap, p2);
        printk("释放 256B 后\n");
    }

    void *p4 = k_heap_alloc(&my_heap, 300, K_NO_WAIT);
    printk("再分配 300B: %p %s\n", p4, p4 ? "(成功)" : "(失败)");
}

int main(void)
{
    printk("实验 09 - 内存 slab & heap\n");
    test_mem_slab();
    test_heap();
    while (1) {
        k_msleep(1000);
    }
    return 0;
}
```

### prj.conf

```ini
CONFIG_HEAP_MEM_POOL_SIZE=1024
CONFIG_PRINTK=y
```

### app.overlay（可选）

```dts
/* QEMU 实验无需 overlay */
```

---

## 运行命令

```bash
west build -b qemu_cortex_m3
west build -t run

# 退出 QEMU
Ctrl + A → X
```

---

## 现象

slab：成功分配 8 个 64B 块，释放前 4 个后额外分配成功（块复用，无碎片）。heap：成功分配 128/256/512B，释放 256B 后再申请 300B 失败，验证了碎片导致无连续可用空间。

---

## 坑

**现象**：`k_malloc` / `k_heap_alloc` 始终返回 NULL
**原因**：未设置 `CONFIG_HEAP_MEM_POOL_SIZE`，默认为 0，无堆可用
**解决**：在 `prj.conf` 中设置合理大小（如 1024、2048）

---

**现象**：长时间运行后无法分配新内存
**原因**：申请后未 `k_free`，内存泄漏
**解决**：严格配对 alloc 与 free，free 后建议 `ptr = NULL`

---

**现象**：编译报 `k_mem_slab_alloc` 参数错误
**原因**：传参错误，需传 `&mem`（`void **` 类型）
**解决**：正确写法：`k_mem_slab_alloc(&slab, &mem, timeout)`

---

## 结论

固定 slab 分配为 O(1) 时间、无碎片，适合固定尺寸频繁分配；可变 heap 灵活但易碎片，分配时间不确定。嵌入式开发中应优先静态分配，减少运行时 malloc 使用，警惕内存泄漏与碎片风险。换成 STM32F103ZE 实板，两种分配机制与 QEMU 完全一致，但 RAM 仅 64KB，heap 大小需谨慎规划。

---

## 疑问与解答

**Q：不 free 会怎样？**

A：内存泄漏，占用直到程序结束，长期运行可能耗尽 RAM，导致后续分配全部失败。

---

**Q：栈和堆的本质区别？**

A：栈自动管理、LIFO、无碎片、生存期为函数级；堆手动管理、任意大小、易碎片、生存期直到显式 free。

---

**Q：为什么嵌入式尽量少用 `k_malloc`？**

A：碎片风险、分配时间不确定、泄漏隐患、RAM 有限，这四点在嵌入式场景下代价都很高。

---

## 反哺

→ [[01-Concepts/k_mem_slab]]
→ [[01-Concepts/k_heap]]
→ [[01-Concepts/MemoryManagement]]
