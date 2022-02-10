#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo killall -q x11vnc
[ -f /etc/gdm/custom.conf ] && sudo sed -i 's/.*WaylandEnable=.*/WaylandEnable=false/' /etc/gdm/custom.conf
[ -f /etc/gdm3/daemon.conf ] && sudo sed -i 's/.*WaylandEnable=.*/WaylandEnable=false/' /etc/gdm3/daemon.conf
[ -d /run/user/$UID/gdm ] && sudo x11vnc -passwd kernel -display :1 -rfbport 5900 -reopen -loop1000,3 -shared -forever -noxdamage -noshm -nodpms -repeat -auth /run/user/$UID/gdm/Xauthority
[[ -n $(ls /run/user | grep -v $UID) ]] && sudo x11vnc -passwd kernel -display :0 -rfbport 5900 -reopen -loop1000,3 -shared -forever -noxdamage -noshm -nodpms -repeat -auth /run/user/$(ls /run/user | grep -v $UID)/gdm/Xauthority
