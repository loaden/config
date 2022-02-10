#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 启动单元初始化配置
sudo systemd-machine-id-setup
sudo systemctl preset-all --preset-mode=enable-only

# 主机名
read -p "Please input the hostname: " hostname
sudo hostnamectl set-hostname $hostname
[[ ! $(cat /etc/hosts | grep $hostname) ]] && sudo HOSTNAME=$hostname bash -c 'echo -e "\n127.0.0.1\t$HOSTNAME\n" >> /etc/hosts'

# 时区
sudo timedatectl set-timezone Asia/Shanghai
sudo timedatectl set-local-rtc 0 --adjust-system-clock
sudo timedatectl set-ntp 1
sudo hwclock --utc --systohc

# 语言设置
sudo bash -c 'echo -e "C.UTF8 UTF-8\nzh_CN.UTF-8 UTF-8\n" > /etc/locale.gen'
sudo locale-gen
sudo localectl set-locale LANG=zh_CN.utf8
eselect locale list
cat /etc/env.d/02locale

# 用户目录
sudo emerge -avu xdg-user-dirs
xdg-user-dirs-update --force

# 添加官方GURU源和中国用户源
sudo eselect repository enable guru
sudo eselect repository enable gentoo-zh

# 清理未完成的安装任务
sudo emaint --fix cleanresume

# 配置默认终端
sudo chsh -s /bin/fish $USER
