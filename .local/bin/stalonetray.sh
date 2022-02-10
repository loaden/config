#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

[ ! -f /bin/stalonetray ] && sudo apt install -y stalonetray

read -p "请输入托盘背景颜色，默认0x3c5159，建议用取色软件读取桌面壁纸右下角的颜色：" bg_color
bg_color=${bg_color: 0-6}
[[ ! $bg_color ]] && bg_color=3c5159
exec_command="stalonetray -geometry 1x1-5-5 --config /dev/null --window-layer bottom --window-strut right --window-type dock --dockapp-mode simple --slot-size 24 --icon-size 16 --grow-gravity NE --icon-gravity NE --skip-taskbar --background '#$bg_color' &"

cat > ~/.config/autostart/stalonetray.desktop <<EOF
[Desktop Entry]
Name=stalonetray
Name[zh_CN]=托盘图标
Exec=bash -c "sleep 1.5 && $exec_command" &
Icon=application-default-icon
Type=Application
X-GNOME-Autostart-enabled=true
Terminal=false
EOF

killall -q stalonetray
bash -c "$exec_command" &

echo 托盘背景色已设置成：#$bg_color
echo 配置完成
