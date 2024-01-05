---
title: nginx安装和使用
date: 2022-6-22 12:26:12
tags:
  - linux
  - soft
  - nginx
categories: linux软件
---

安装
---

- `sudo apt-get install nginx`
    - 配置文件`/etc/nginx/nginx.conf`
        - `include /etc/nginx/conf.d/*.conf`
- `sudo /etc/init.d/nginx start`
- `nginx -s reload`
- `curl http://localhost/`或者`sudo nginx -t` # test

配置
---

blog.conf:

```config
# limit_req_zone $binary_remote_addr zone=addr:10m rate=4r/m;
server {
    # http socket
    listen       443 ssl;
    server_name  luckyu.com.cn;

    charset utf-8;
    # access_log /var/log/nginx/blog.access.log main;

    ssl_certificate   blog/luckyu.com.cn_bundle.pem;
    ssl_certificate_key  blog/luckyu.com.cn.key;
    ssl_session_timeout 5m;
    # ssl_ciphers ....;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    location / {
        # limit_req zone=one;
        include uwsgi_params;
        # 接口映射 映射本地服务接口
        # uwsgi_pass unix:/tmp/uwsgi.sock;
        # proxy_pass http://localhost:8000;
        # 配置静态资源路径
        root /home/baiker/hexo/blog/public;
        index index.html;
        rewrite ^/(.*)$ /$1 break;
    }
    # 端口映射 重定向评论接口
    location /comments {
        include uwsgi_params;
        uwsgi_pass unix:/tmp/uwsgi.sock;
        proxy_pass http://127.0.0.1:8080;
    }
}

server {
    listen 80;
    server_name www.luckyu.com.cn;
    # 重定向
    rewrite ^(.*)$ https://${server_name}$1 permanent;
}
```

使用公共配置
---

`include conf.d/proxy.inc;`

proxy.inc:(demo)

```
expires off;
proxy_set_header Host $host;
proxy_set_header X-Real-Ip $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Host $host:$server_port;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_connect_timeout 7d;
proxy_send_timeout 7d;
proxy_read_timeout 7d;
add_header backendIP $upstream_addr;
add_header backendCode $upstream_status;
break;
```
