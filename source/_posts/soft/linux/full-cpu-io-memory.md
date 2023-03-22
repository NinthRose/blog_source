---
title: 打满cpu/io/memory
date: 2023-3-22 12:26:12
tags:
  - linux
categories: linux
---

都涉及到[dd](http://c.biancheng.net/linux/dd.html)命令

以及linux一些特殊文件
- /dev/null，也叫空设备，小名“无底洞”。任何写入它的数据都会被无情抛弃。
- /dev/zero，可以产生连续不断的 null 的流（二进制的零流），用于向设备或文件写入 null 数据，一般用它来对设备或文件进行初始化。
- /dev/urandom，它是“随机数设备”，它的本领就是可以生成理论意义上的随机数。

dd demo：
```bash
#向磁盘上写一个大文件, 来看写性能
[root@roclinux ~]# dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file

#从磁盘上读取一个大文件, 来看读性能
[root@roclinux ~]# dd if=/root/1Gb.file bs=64k | dd of=/dev/null

# 上面命令生成了一个 1GB 的文件 1Gb.file，下面我们配合 time 命令，可以看出不同的块大小数据的写入时间，从而可以测算出到底块大小为多少时可以实现最佳的写入性能。
[root@roclinux ~]# time dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file
[root@roclinux ~]# time dd if=/dev/zero bs=2048 count=500000 of=/root/1Gb.file
[root@roclinux ~]# time dd if=/dev/zero bs=4096 count=250000 of=/root/1Gb.file
[root@roclinux ~]# time dd if=/dev/zero bs=8192 count=125000 of=/root/1Gb.file
```

cpu
---

```base
# 打满4核cpu机器 lscpu
for i in $(seq 1 4);do
    dd if=/dev/zero of=/dev/null &
done
```

memory
---

运行这个脚本，然后使用free命令查看MEM的使用情况

```bash
#!/bin/bash
# 占用1GB内存1个小时. 注意需要可以mount的权限
mkdir /tmp/memory
mount -t tmpfs -o size=1024M tmpfs /tmp/memory
dd if=/dev/zero of=/tmp/memory/block
sleep 3600
rm /tmp/memory/block
umount /tmp/memory
rmdir /tmp/memory
```

io
---

运行这个脚本，然后使用iostat命令查看IO的使用情况

```bash
while true; do
    dd if=/dev/urandom of=/burn bs=1M count=1024 iflag=fullblock
done
```

if指定输入的文件名，of指定输出的文件名，bs同时设置读写块的大小为1M，count是指仅拷贝1024个块，块大小等于bs指定的字节数。iflag=fullblock表示堆积满block。
