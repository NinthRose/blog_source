---
title: django 单元测试覆盖率
tags:
  - python
  - django
date: 2022-11-09 21:46:47
updated: 2022-11-09 21:46:47
categories: 学习笔记
---

```bash
# 安装
pip install coverage

# 清楚缓存文件 .coverage
coverage erase

# 执行测试
coverage run manage.py test

# 生成测试报告
coverage report

# 生成html报告
coverage html
```

配置测试代码范围`.coveragerc`：

```rc
[run]
branch = True
source = .
omit =
   manage.py
   venv/*
   models.py

[report]
show_missing = True
skip_covered = True
```
