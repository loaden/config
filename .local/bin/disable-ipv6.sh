#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

sudo bash -c 'echo -e "net.ipv6.conf.all.disable_ipv6=1\nnet.ipv6.conf.default.disable_ipv6=1" > /etc/sysctl.d/disable-ipv6.conf'
sudo sysctl -p /etc/sysctl.d/disable-ipv6.conf
echo "查看配置："
sudo sysctl -a |grep ipv6 |grep disable
