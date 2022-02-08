#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

kill -9 `pgrep wine` &> /dev/null
kill -9 `ps aux |grep -i "C:" |grep "exe" |egrep -i "Windows|Program" |grep -v grep |awk '{print $2}'` &> /dev/null
kill -9 `ps aux |egrep '/QQ|/TIM|/WeChat' |grep "exe" |grep -v grep |awk '{print $2}'` &> /dev/null
kill -9 `ps aux |grep -i 'tencent' |grep "exe" |grep -v grep |awk '{print $2}'` &> /dev/null

read -p "请按任意键退出" -n 1
