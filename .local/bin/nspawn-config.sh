#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

read -p "禁用宿主机MIT-SHM内存共享扩展？[y/N]" choice
case $choice in
Y | y) sudo DISABLE_HOST_MITSHM=1 ~/.dev/Projects/nspawn-deepinwine/config.sh;;
N | n | '') sudo DISABLE_HOST_MITSHM=0 ~/.dev/Projects/nspawn-deepinwine/config.sh;;
*) echo 错误选择，程序意外退出！;;
esac
