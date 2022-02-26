#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 启动单元初始化配置
sudo systemd-machine-id-setup
sudo systemctl preset-all --preset-mode=enable-only
# sudo systemctl --global enable pipewire.socket

# 主机名
read -p "Please input the hostname: " hostname
sudo hostnamectl set-hostname $hostname
[[ ! $(cat /etc/hosts | grep $hostname) ]] && sudo HOSTNAME=$hostname bash -c 'echo -e "\n127.0.0.1\t$HOSTNAME.me $HOSTNAME\n" >> /etc/hosts'

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
# eselect locale set <number>

# 用户目录
sudo emerge -avu xdg-user-dirs
xdg-user-dirs-update --force

# 添加官方GURU源和中国用户源
sudo emerge -avu eselect-repository
sudo eselect repository enable guru
sudo eselect repository enable gentoo-zh

# 清理未完成的安装任务
sudo emaint --fix cleanresume

# 配置默认终端
sudo chsh -s /bin/bash $USER

# 重载UDEV规则
sudo udevadm control --reload
sudo udevadm trigger

# 电源管理
sudo systemctl enable acpid.service
sudo systemctl enable thermald.service

# 用户组
sudo usermod -aG wheel,audio,video,plugdev,pcap $USER

# udisks 支持 NTFS3
sudo bash -c 'echo -e "[defaults]\nntfs_defaults=uid=$UID,gid=$GID,noatime,prealloc" > /etc/udisks2/mount_options.conf'

# 允许弱密码
sudo sed -i 's/enforce=everyone/enforce=none/g' /etc/security/passwdqc.conf
