#!/bin/bash

cd $(dirname $0)

year=2025

for m in {1..9};do
    M="0$m"
    for d in {1..31};do
        if [ $d -lt 10 ];then
            D="0$d"
        else
            D="$d"
        fi
        if [ -f $year$M$D.jpg ];then
            continue
        fi
        wget https://tupian.sioe.cn/b/bing-home-image/pic/$year$M$D.jpg --no-check-certificate
    done
done
