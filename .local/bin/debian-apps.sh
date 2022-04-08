#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

#steam#begin#
#sudo dpkg --add-architecture i386
#sudo apt update
#sudo apt autopurge -y
#sudo apt install steam -y #STEAM游戏平台
#steam#begin#

# 应用
sudo apt install firefox firefox-locale-zh-hans -y # Firefox
[ "$?" = "0" ] || sudo apt install firefox-esr firefox-esr-l10n-zh-cn -y
sudo apt purge chromium -y
sudo apt install fcitx5 fcitx5-rime -y
sudo apt purge ibus*

sudo apt install apt-file -y #搜索包
sudo apt install apt-transport-https ca-certificates -y #https源
sudo apt install aria2 -y #下载
sudo apt install audacious -y #音频播放器
#sudo apt install audacity -y #音频编辑器
sudo apt install baobab --no-install-recommends -y #磁盘使用情况分析器
sudo apt install bash-completion -y  #终端自动完成
#sudo apt install blender -y #视频剪辑与动画
sudo apt install build-essential -y #开发
#sudo apt install evince -y #文档查看器
sudo apt install fdupes -y #重复文件查找
#sudo apt install filezilla -y #FTP客户端
#sudo apt install flameshot -y #截图
sudo apt install flatpak -y  #Flatpak
#sudo apt install galculator -y #计算器
sudo apt install gimp -y #图像编辑器
sudo apt install git -y #版本管理
sudo apt install gnome-disk-utility -y #磁盘
sudo apt install gnome-mines -y #扫雷
sudo apt install gnome-nibbles -y #贪食蛇
#sudo apt install gparted -y #分区编辑器
sudo apt install htop -y #进程查看器
#sudo apt install inkscape -y #矢量图编辑
#sudo apt install kazam -y #录屏
#sudo apt install kdenlive -y #视频剪辑
#sudo apt install krita krita-l10n -y #数字绘画
sudo apt install mpv -y #视频播放器
#sudo apt install nemo gnome-terminal cinnamon-l10n --no-install-recommends -y #文件管理器和终端
sudo apt install neofetch --no-install-recommends -y #系统信息
#sudo apt install nmap -y #端口扫描
#sudo apt install obs-studio -y #录屏推流
#sudo apt install quadrapassel -y #俄罗斯方块
sudo apt install remmina -y #远程桌面
#sudo apt install shotwell -y #图像查看器
#sudo apt install supertuxkart -y #赛车
sudo apt install system-config-printer -y  #打印机管理
sudo apt install telnet -y #远程访问
#sudo apt install timeshift -y #时光再现
sudo apt install traceroute -y #路由跟踪
sudo apt install tree -y #树
sudo apt install unar -y #解压缩
#sudo apt install vlc -y #视频播放器
#sudo apt install vokoscreen -y #录屏
#sudo apt install x11vnc -y #远程桌面
sudo apt install zstd -y #最快解压
