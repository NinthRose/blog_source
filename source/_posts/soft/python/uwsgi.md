---
title: uwsgi的使用配置
tags:
  - python
  - django
  - uwsgi
date: 2022-09-09 15:46:47
updated: 2022-09-09 15:46:47
categories: 学习笔记
---

intro
---

WSGI 全称是 Web Server Gateway Interface，也就是 Web 服务器网关接口，是一个web服务器（如uWSGI服务器）与web应用（如用Django或Flask框架写的程序）通信的一种规范。WSGI包含了很多自有协议，其中一个是uwsgi，它用于定义传输信息的类型。

uWSGI是一个Python Web服务器,它实现了WSGI协议、uwsgi、http等协议，常在部署Django或Flask开发的Python Web项目时使用，作为连接Nginx与应用程序之间的桥梁。

WSGI/uwsgi/uWSGI
---

- WSGI全名Web Server Gateway Interface，是一个Web服务器（如uWSGI服务器）与web应用（如用Django或Flask框架写的程序）通信的一种规范
- uwsgi是WSGI通信规范中的一种自有协议
- uWSGI是Python Web服务器，实现了WSGI通信规范和uwsgi协议

why
---

Nginx处理静态文件非常优秀，却不能直接与我们的Python Web应用程序进行交互。Django和Flask本身是Web框架，并不是Web服务器，它们自带的runserver和Werkzeug也仅仅用于开发测试环境，生产环境中处理并发的能力太弱。

> 客户端 <-> Nginx <-> uWSGI <-> Python应用程序(Django, Flask)

install
---

`pip install uwsgi` or `conda install -c conda-forge uwsgi`

command
---

- start: `uwsgi --ini uwsgi.ini`
- stop: `uwsgi --stop $PID_FILE`

配置文件demo
---

`%()`取值，配置文件如下uwsgi.ini:

```ini
[uwsgi]
uid=<user> # Ubuntu系统下默认用户名
gid=<group> # Ubuntu系统下默认用户组
project=<project_name>  # 项目名
base=/home/<user> # 项目根目录

home=%(base)/%(project_venv_dir) # 设置项目虚拟环境,Docker部署时不需要
chdir=%(base)/%(project_dir) # 设置工作目录
module=%(project).wsgi:application # wsgi文件位置

master=True # 主进程
processes=2 # 同时进行的进程数，一般

# 以下uwsgi与nginx通信手段3选一即可，nginx配置要对应

# 选项1, 使用unix socket与nginx通信，仅限于uwsgi和nginx在同一主机上情形
# Nginx配置中uwsgi_pass应指向同一socket文件
# socket=/run/uwsgi/%(project).sock
# 对应nginx中配置如下
# include /etc/nginx/uwsgi_params
# uwsgi_pass unix:/xxx/xxx/xxx.sock

# 选项2，使用TCP socket与nginx通信
# Nginx配置中uwsgi_pass应指向uWSGI服务器IP和端口
# socket=0.0.0.0:8000 或则 socket=:8000
socket:9999
# 对应nginx中配置如下
# include /etc/nginx/uwsgi_params
# uwsgi_pass <ip>:<port>

# 选项3，使用http协议与nginx通信
# Nginx配置中proxy_pass应指向uWSGI服务器一IP和端口
# http=0.0.0.0:8000
# 对应nginx中配置如下
# include /etc/nginx/uwsgi_params
# uwsgi_pass http://<ip>:<port>

# socket权限设置
chown-socket=%(uid):www-data
chmod-socket=664


# 进程文件
pidfile=/tmp/%(project).pid


# 以后台守护进程运行，并将log日志存于temp文件夹。
# 没有时直接运行
daemonize=/var/log/uwsgi/%(project).log


# 服务停止时，自动移除unix socket和pid文件
vacuum=True


# 为每个工作进程设置请求数的上限。当处理的请求总数超过这个量，进程回收重启。
max-requests=5000


# 当一个请求花费的时间超过这个时间，那么这个请求都会被丢弃。
harakiri=60


#当一个请求被harakiri杀掉会输出一条日志
harakiri-verbose=true


# uWsgi默认的buffersize为4096，如果请求数据超过这个量会报错。这里设置为64k
buffer-size=65536


# 如果http请求体的大小超过指定的限制，打开http body缓冲，这里为64k
post-buffering=65536


#开启内存使用情况报告
memory-report=true


#设置平滑的重启（直到处理完接收到的请求）的长等待时间(秒)
reload-mercy=10


#设置工作进程使用虚拟内存超过多少MB就回收重启
reload-on-as=1024
```

nginx demo
---

```
server {
    listen 8888:
    charset utf-8;

    location / {
        root /app/project/dist;
        index index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

    location /aaa/bbb {
        uwsgi_pass localhost:9999;
        include /etc/nginx/uwsgi_params;

        add_header backendIP $upstream_addr;
        add_header backendCode $upstream_status;
    }
}
```
