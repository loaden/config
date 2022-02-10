#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo killall -q x11vnc
[[ -n $(sudo ls /var/run/lightdm/root/ | grep 1) ]] && sudo x11vnc -passwd kernel -display :1 -rfbport 5900 -reopen -loop1000,2 -shared -forever -noxdamage -nodpms -repeat -auth /var/run/lightdm/root/:1
[[ -n $(sudo ls /var/run/lightdm/root/ | grep 0) ]] && sudo x11vnc -passwd kernel -display :0 -rfbport 5900 -reopen -loop1000,3 -shared -forever -noxdamage -nodpms -repeat -auth /var/run/lightdm/root/:0
