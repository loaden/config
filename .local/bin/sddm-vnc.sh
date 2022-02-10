#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo killall -q x11vnc
sudo x11vnc -passwd kernel -display :0 -rfbport 5900 -reopen -loop1000,5 -shared -forever -noxdamage -nodpms -repeat -auth /var/run/sddm/*
