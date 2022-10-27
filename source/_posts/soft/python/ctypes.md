---
title: 使用ctypes调用动态库
tags:
  - python
  - C/C++
  - ctypes
date: 2022-10-11 14:58:36
categories: 学习笔记
---

intro
---

ctypes是python的一个函数库，提供和C语言兼容的数据类型，可以直接调用动态链接库中的导出函数。
为了使用ctypes，必须依次完成以下步骤：

- 加载动态链接库
    - cdll
    - windll
    - oledll
- 将python对象转换成ctypes所能识别的参数
- 使用ctypes所能识别的参数调用动态链接库中的函数

> 仅支持简单使用，详情请参考官方文档[python doc](https://docs.python.org/zh-cn/3.7/library/ctypes.html)

基础类型
---

| ctypes 类型 | C 类型 | Python 类型 |
| --- | --- | --- |
| c_bool | _Bool |  bool (1) |
| c_char | char | 单字符字节对象 |
| c_wchar | wchar_t | 单字符字符串 |
| c_byte | char | 整型 |
| c_ubyte | unsigned char | 整型 |
| c_short | short | 整型 |
| c_ushort | unsigned short | 整型 |
| c_int | int | 整型 |
| c_uint | unsigned int | 整型 |
| c_long | long | 整型 |
| c_ulong | unsigned long | 整型 |
| c_longlong | __int64 或 long long | 整型 |
| c_ulonglong | unsigned __int64 或 unsigned long long | 整型 |
| c_size_t | size_t | 整型 |
| c_ssize_t | ssize_t 或 Py_ssize_t | 整型 |
| c_float | float | 浮点数 |
| c_double | double | 浮点数 |
| c_longdouble | long double | 浮点数 |
| c_char_p | char * (以 NUL 结尾) | 字节串对象或 None |
| c_wchar_p | wchar_t * (以 NUL 结尾) | 字符串或 None |
| c_void_p | void * | int 或 None |

usage
---

cdll demo:
```python
import sys, ctypes
from platform import system, architecture
windows = 'windows' in system.lower()
# working on architecture() in sys.byteorder
if windows:
    api = ctypes.WinDLL('lib.dll')
else:
    api = ctypes.CDLL('lib.so')

# attention long: longlong 8字节，int 4字节，long不稳定，尽量不要用
long_effect = sizeof(c_long) != sizeof(c_int)
if not long_effect:
    c_long = c_longlong
    c_ulong = c_ulonglong
```

simple:

```python
# int add(int a, int b)

from ctypes import *
demo_api = CDLL("lib.so")

demo_api.add.argtypes = [c_int, c_int]      # 定义输入类型
demo_api.add.restype = c_int                # 定义返回类型
res = demo_api.add(c_int(5), c_int(6))      # 调用函数
print(res) # 11
```

---

pointer demo:

```python
# int create_handle(void *&handle)
# int free_handle(void *handle, int i)

from ctypes import *
demo_api = CDLL("lib.so")

demo_api.create_handle.argtypes = [POINTER(c_void_p)]
demo_api.create_handle.restype = c_int
req = c_void_p()
res = demo_api.create_handle(byref(req))

demo_api.free_handle.argtypes = [c_void_p, c_int]   # 多个参数
demo_api.free_handle.restype = c_int
res = demo_api.free_handle(req, 9)
```

---

struct demo:

```python
# struct data_req
# {
#     char c;
#     int list[256];
#     unsigned int i;
# }
# int request(data_req *data)

from ctypes import *
demo_api = CDLL("lib.so")

class REQ(Structure):
    _pack_ = True  # 1字节对齐
    _fields_ = [
        ("c", c_char),
        ("list", c_int * 256),
        ("i", c_uint),
    ]

demo_api.request.argtypes = [REQ]
demo_api.request.restype = c_int
req = REQ('1', [2,3,4], 3)
res = demo_api.request(req)
```

---

callback demo:

```python
# struct data_req
# {
#     char c;
#     int list[256];
#     unsigned int i;
# }
# typedef void (*callback)(int i, data_req *data)
# int func(callback c)

from ctypes import *
demo_api = CDLL("lib.so")

class REQ(Structure):
    _fields_ = [
        ("c", c_char),
        ("list", c_int * 256),
        ("i", c_uint),
    ]

if windows:
    callback_type = ctypes.WINFUNCTYPE(c_int, REQ)
else:
    callback_type = ctypes.CFUNCTYPE(c_int, REQ)

def print_log(i, data):
    print(i, data)  # print object's type
    print(data.c)  # print a char
    print(data.__dict__)  # nothing

demo_api.func.argtypes = [c_void_p]
demo_api.func.restype = c_int
callback_func = callback_type(print_log)
res = demo_api.func(callback_func)

# 不可使用临时变量，垃圾回收之后，回调函数不可用
# res = demo_api.func(callback_type(print_log))
```
