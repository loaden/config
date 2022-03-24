#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 主机名
read -p "Please input the hostname: " hostname
sudo hostnamectl set-hostname $hostname
[[ ! $(cat /etc/hosts | grep $hostname) ]] && sudo HOSTNAME=$hostname bash -c 'echo -e "\n127.0.0.1\t$HOSTNAME\n" >> /etc/hosts'

# 时区
sudo timedatectl set-timezone Asia/Shanghai
sudo timedatectl set-local-rtc 0 --adjust-system-clock
sudo timedatectl set-ntp 1
sudo hwclock --utc --systohc

# 软件源
sudo pacman -Syy
sudo pacman -S reflector --noconfirm --needed
sudo reflector --verbose -c CN --protocol https --sort rate --latest 10 --save /etc/pacman.d/mirrorlist
sudo perl -0777 -pi -e 's/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
[[ ! $(cat /etc/pacman.conf | grep archlinuxcn) ]] && sudo bash -c 'echo -e "\n[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf'
sudo pacman -Syy
sudo pacman -S archlinuxcn-keyring --noconfirm
sudo pacman -S archlinux-keyring --noconfirm

# 中文
sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo sed -i 's/# zh_CN.UTF-8/zh_CN.UTF-8/g' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=zh_CN.UTF-8

# 重启生效
read -p "完事。" -n 1
