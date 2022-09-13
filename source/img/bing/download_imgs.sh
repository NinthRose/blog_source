#!/bin/bash

cd $(dirname $0)

for m in {1..9};do
    M="0$m"
    for d in {1..31};do
        if [ $d -lt 10 ];then
            D="0$d"
        else
            D="$d"
        fi
        if [ -f 2022$M$D.jpg ];then
            continue
        fi
        wget https://tupian.sioe.cn/b/bing-home-image/pic/2022$M$D.jpg --no-check-certificate
    done
done
