#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

killall -q stalonetray
exec_command="$(awk -F "=" '/Exec/ {print $2}' ~/.config/autostart/stalonetray.desktop)"
bash -c "$exec_command"
