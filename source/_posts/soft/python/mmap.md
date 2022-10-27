---
title: 内存映射文件操作
tags:
  - python
  - file
date: 2022-10-27 11:35:53
categories: 学习笔记
---

demo
---

```python
import mmap

with open('demo.json', 'r+') as file:
    with mmap.mmap(file.fileno(), 0, access=mmap.ACCESS_WRITE) as m:
        m[3:5] = 'test'

```
