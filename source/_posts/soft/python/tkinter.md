---
title: tkinter(python GUI)
tags:
  - python
  - GUI
date: 2022-10-27 11:35:53
categories: 学习笔记
---

intro
---

python GUI有很多，这里只学习使用最基础稳定的。

sample demo
---

Label 部分属性介绍
> - width 单位是字符宽度
> - wraplength 单位是px
> - justify 多行时生效，默认居中
> - font 字体


```python
#from tkinter import *
root = Tk(className='title')
root.geometry('1000x618')  # 数字中间是小写字母

title = Label(root, text='title')
text = StringVar()
body = Label(root, textvariable=text, wraplength=width//2, justify='left', font=('Helvetica', 12))

title.pack()
body.pack()

info = 'this is a line.\nthis is a new line. that is too long'
text.set(info)

root.mainloop()
```

listbox demo
---

```python
label = Label(root, text='两个列表展示')
listb  = Listbox(root)
listb2 = Listbox(root)

li     = ['C','python','php','html','SQL','java']
movie  = ['CSS','jQuery','Bootstrap']


for item in li:
    listb.insert(0, item)

for item in movie:
    listb2.insert('end', item)

# 简单布局
label.pack()
listb.pack()
listb2.pack()
```

> 布局pack和grid不要一起食用，会引起不适～

login for grid demo
---

grid 为表格布局

> - padx,pady 分别为单元格之间前后和上下的外间距
> - ipadx,ipady 分别为单元格之间前后和上下的内间距
> - columnspan,rowspan 分别为当前内容跨单元格数量，默认为1
> - sticky 为排列方式，默认为居中，在列内容长度不同时，表现比较长短不一。
>   - 可设置的值为’n’, ‘ne’, ‘e’, ‘se’, ‘s’, ‘sw’, ‘w’, ‘nw’;
>   - ‘e’、‘w’、‘s’、'n’分别表示东西南北。

```python
from tkinter import W, E
login = Frame(root)
Label(login, text='用户名：').grid(row=0, column=0, padx=5, pady=5, sticky=W)
Label(login, text='密码：').grid(row=1, column=0, padx=5, pady=5, sticky=E)

name = Entry(login)
name.grid(row=0, column=1)

password = Entry(login, show='*')
password.grid(row=1, column=1)

def login_checker():
    pass

Button(login, text='登陆', command=login_checker).grid(row=2, column=2, padx=10, pady=10)

login.grid(row=0, column=1, padx=10, pady=10)

```

下拉菜单
---

```python
var = StringVar()
box = Combobox(root, textvariable=var)
box['value'] = ['value1', 'value2']

box.current(0) # 默认第一个

# 获取选择内容
box.get()
var.get()
```
