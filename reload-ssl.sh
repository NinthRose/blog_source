#!/bin/bash

cd $(dirname $0)
set -x
path=$(pwd)

rm -rf luckyu.com.cn_nginx
unzip ~/luckyu.com.cn_nginx.zip
sudo rm -rf /etc/nginx/blog
sudo mv $path/luckyu.com.cn_nginx /etc/nginx/blog
sudo chown -R root:root /etc/nginx/blog
sudo nginx -s reload

set +x
