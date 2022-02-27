#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 启动单元初始化配置
sudo systemd-machine-id-setup
sudo systemctl preset-all --preset-mode=enable-only
# sudo systemctl --global enable pipewire.socket

# 主机名
if [ "$(hostname)" != "lucky" ]; then
    read -p "Please input the hostname: " hostname
    sudo hostnamectl set-hostname $hostname
    if [[ ! $(cat /etc/hosts | grep $hostname) ]]; then
        sudo HOSTNAME=$hostname bash -c 'echo -e "\n127.0.0.1\t$HOSTNAME.me $HOSTNAME\n" >> /etc/hosts'
    fi
fi

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
sudo eselect locale set zh_CN.utf8
eselect locale list

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

# 禁用字体配置
sudo eselect fontconfig disable 10-hinting-slight.conf
sudo eselect fontconfig disable 10-scale-bitmap-fonts.conf
sudo eselect fontconfig disable 20-unhint-small-vera.conf
sudo eselect fontconfig disable 30-metric-aliases.conf
sudo eselect fontconfig disable 40-nonlatin.conf
sudo eselect fontconfig disable 45-generic.conf
sudo eselect fontconfig disable 45-latin.conf
sudo eselect fontconfig disable 49-sansserif.conf
sudo eselect fontconfig disable 50-user.conf
sudo eselect fontconfig disable 51-local.conf
sudo eselect fontconfig disable 60-generic.conf
sudo eselect fontconfig disable 60-latin.conf
sudo eselect fontconfig disable 65-fonts-persian.conf
sudo eselect fontconfig disable 65-nonlatin.conf
sudo eselect fontconfig disable 69-unifont.conf
sudo eselect fontconfig disable 80-delicious.conf
sudo eselect fontconfig disable 90-synthetic.conf

# 启用字体配置
sudo eselect fontconfig enable 11-lcdfilter-default.conf
# sudo eselect fontconfig enable 10-hinting-slight.conf
# sudo eselect fontconfig enable 10-scale-bitmap-fonts.conf
# sudo eselect fontconfig enable 20-unhint-small-vera.conf
# sudo eselect fontconfig enable 30-metric-aliases.conf
# sudo eselect fontconfig enable 40-nonlatin.conf
# sudo eselect fontconfig enable 45-generic.conf
# sudo eselect fontconfig enable 45-latin.conf
sudo eselect fontconfig enable 49-sansserif.conf
sudo eselect fontconfig enable 50-user.conf
# sudo eselect fontconfig enable 51-local.conf
# sudo eselect fontconfig enable 60-generic.conf
sudo eselect fontconfig enable 60-latin.conf
# sudo eselect fontconfig enable 65-fonts-persian.conf
# sudo eselect fontconfig enable 65-nonlatin.conf
# sudo eselect fontconfig enable 69-unifont.conf
# sudo eselect fontconfig enable 80-delicious.conf
# sudo eselect fontconfig enable 90-synthetic.conf


# 刷新字体缓存
sudo -E fc-cache -rv

# 检查字体匹配
fc-match Arial
fc-match --verbose sans-serif

# 更新环境变量
sudo env-update
source /etc/profile
