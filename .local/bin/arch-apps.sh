#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

# 桌面软件
sudo pacman -Syy
sudo pacman -S audacious --noconfirm --needed #音乐播放器
sudo pacman -S bash-completion --noconfirm --needed #终端自动完成
#sudo pacman -S cups ghostscript gsfonts hplip hplip-plugin --noconfirm --needed #打印机
sudo pacman -S firefox firefox-i18n-zh-cn --noconfirm --needed #浏览器
sudo pacman -S git --noconfirm --needed #版本管理
sudo pacman -S htop --noconfirm --needed #进程查看器
sudo pacman -S inetutils --noconfirm --needed #telnet
sudo pacman -S neofetch --noconfirm --needed #系统信息
sudo pacman -S fcitx5-im fcitx5-rime --noconfirm --needed #输入法
sudo pacman -S gimp --noconfirm --needed #图像处理
sudo pacman -S mpv --noconfirm --needed #视频播放器
#sudo pacman -S simple-scan --noconfirm --needed #扫描仪
sudo pacman -S traceroute --noconfirm --needed #路由跟踪
sudo pacman -S yay base-devel --noconfirm --needed #AUR
sudo pacman -S gnome-tweaks --noconfirm --needed #优化
sudo pacman -S remmina libvncserver --noconfirm --needed #远程

# AUR软件
yay -S visual-studio-code-bin --noconfirm --needed #Visual Studio Code
yay -S --noconfirm --needed dingtalk-bin #钉钉
yay -S --noconfirm --needed wps-office wps-office-mui-zh-cn #WPS

# 扩展
sudo pacman -S --noconfirm --needed gnome-shell-extension-dash-to-dock
sudo pacman -S --noconfirm --needed gnome-shell-extension-appindicator

# 主题
sudo pacman -S tela-icon-theme-git --noconfirm --needed
sudo pacman -S papirus-icon-theme --noconfirm --needed
sudo pacman -S graphite-cursor-theme-git --noconfirm --needed
yay -S numix-icon-theme-git --noconfirm --needed

# 远程连接
sudo pacman -S openssh --noconfirm #远程连接
sudo systemctl enable sshd
sudo systemctl start sshd
