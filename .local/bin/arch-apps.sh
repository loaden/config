#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

# 桌面软件
sudo pacman -Syy
sudo pacman -S --noconfirm --needed alacritty #终端
sudo pacman -S --noconfirm --needed audacious #音乐播放器
sudo pacman -S --noconfirm --needed bash-completion #终端自动完成
#sudo pacman -S --noconfirm --needed cups ghostscript gsfonts hplip hplip-plugin #打印机
sudo pacman -S --noconfirm --needed fcitx5-im fcitx5-rime #输入法
sudo pacman -S --noconfirm --needed firefox firefox-i18n-zh-cn #浏览器
sudo pacman -S --noconfirm --needed gimp #图像处理
sudo pacman -S --noconfirm --needed git #版本管理
sudo pacman -S --noconfirm --needed gnome-tweaks #优化
sudo pacman -S --noconfirm --needed htop #进程查看器
sudo pacman -S --noconfirm --needed inetutils #telnet
sudo pacman -S --noconfirm --needed mpv #视频播放器
sudo pacman -S --noconfirm --needed neofetch #系统信息
sudo pacman -S --noconfirm --needed remmina libvncserver #远程
#sudo pacman -S --noconfirm --needed simple-scan #扫描仪
sudo pacman -S --noconfirm --needed traceroute #路由跟踪
sudo pacman -S --noconfirm --needed yay base-devel #AUR

# 主题
sudo pacman -S --noconfirm --needed vimix-gtk-themes-git
sudo pacman -S --noconfirm --needed zorin-desktop-themes
sudo pacman -S --noconfirm --needed mojave-gtk-theme-git
sudo pacman -S --noconfirm --needed tela-icon-theme-git
sudo pacman -S --noconfirm --needed papirus-icon-theme
sudo pacman -S --noconfirm --needed graphite-cursor-theme-git

# 远程连接
sudo pacman -S --noconfirm --needed openssh #远程连接
sudo systemctl enable sshd
sudo systemctl start sshd

# AUR软件
yay -S --noconfirm --needed com.tencent.weixin #微信
yay -S --noconfirm --needed dingtalk-bin #钉钉
yay -S --noconfirm --needed visual-studio-code-bin #Visual Studio Code
yay -S --noconfirm --needed wps-office wps-office-mui-zh-cn #WPS
