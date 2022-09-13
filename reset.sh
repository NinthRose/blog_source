#!/bin/bash

cd $(dirname $0)

[ "$1" == "" ] && exit 1
[ ! $1 -gt 0 ] && exit 1


logs=$(git log --oneline | awk '{print $1}' | head -$1 | tac)


first=""
for i in $logs;do
    if [ "$first" == "" ];then
        git reset --hard $i
        first=$i
    else
        git cherry-pick $i
    fi
    git commit --amend --reset-author
done
