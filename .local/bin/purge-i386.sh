#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo apt purge `dpkg --get-selections | grep ":i386" | awk '{print $1}'`
#sudo apt-get purge ".*:i386"
sudo dpkg --remove-architecture i386
dpkg --print-foreign-architectures

sudo apt autopurge -y
