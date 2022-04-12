#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 启动单元初始化配置
sudo systemd-machine-id-setup
sudo systemctl preset-all --preset-mode=enable-only --now
systemd-machine-id-setup
systemctl --user preset-all --now

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
sudo emerge -avu1 xdg-user-dirs
xdg-user-dirs-update --force

# 清理未完成的安装任务
sudo emaint --fix cleanresume

# 配置默认终端
sudo chsh -s /bin/bash $USER

# 电源管理
sudo systemctl enable acpid.service
sudo systemctl enable thermald.service

# 用户组
sudo usermod -aG audio,video $USER
sudo usermod -aG lpadmin $USER
sudo usermod -aG pcap $USER

# udisks 支持 NTFS3
sudo bash -c 'echo -e "[defaults]\nntfs_defaults=uid=$UID,gid=$GID,noatime,prealloc" > /etc/udisks2/mount_options.conf'

# 别名
if [ -z "$(grep .bash_aliases ~/.bashrc)" ]; then
    echo "[ -f ~/.bash_aliases ] && . ~/.bash_aliases" >> ~/.bashrc
fi

# 允许弱密码
sudo sed -i 's/enforce=everyone/enforce=none/g' /etc/security/passwdqc.conf

# PipeWire替代PulseAudio
sudo sed -i 's/.*autospawn =.*/autospawn = no/g' /etc/pulse/client.conf
sudo sed -i 's/.*daemonize =.*/daemonize = no/g' /etc/pulse/daemon.conf
systemctl --user disable --now pulseaudio
systemctl --user enable --now pipewire pipewire-pulse
systemctl --user daemon-reload
LANG=C pactl info | grep "Server Name"

# 重载UDEV规则
sudo udevadm control --reload
sudo udevadm trigger

# 添加官方GURU源和中国用户源
sudo emerge -avu eselect-repository
sudo eselect repository enable gentoo-zh >/dev/null
sudo eselect repository enable guru >/dev/null
sudo emerge-webrsync

# 禁用字体配置
sudo eselect fontconfig disable 10-hinting-slight.conf >/dev/null 2>&1
sudo eselect fontconfig disable 10-scale-bitmap-fonts.conf >/dev/null 2>&1
sudo eselect fontconfig disable 20-unhint-small-vera.conf >/dev/null 2>&1
sudo eselect fontconfig disable 30-metric-aliases.conf >/dev/null 2>&1
sudo eselect fontconfig disable 40-nonlatin.conf >/dev/null 2>&1
sudo eselect fontconfig disable 45-generic.conf >/dev/null 2>&1
sudo eselect fontconfig disable 45-latin.conf >/dev/null 2>&1
sudo eselect fontconfig disable 49-sansserif.conf >/dev/null 2>&1
sudo eselect fontconfig disable 50-user.conf >/dev/null 2>&1
sudo eselect fontconfig disable 51-local.conf >/dev/null 2>&1
sudo eselect fontconfig disable 60-generic.conf >/dev/null 2>&1
sudo eselect fontconfig disable 60-latin.conf >/dev/null 2>&1
sudo eselect fontconfig disable 65-fonts-persian.conf >/dev/null 2>&1
sudo eselect fontconfig disable 65-nonlatin.conf >/dev/null 2>&1
sudo eselect fontconfig disable 69-unifont.conf >/dev/null 2>&1
sudo eselect fontconfig disable 80-delicious.conf >/dev/null 2>&1
sudo eselect fontconfig disable 90-synthetic.conf >/dev/null 2>&1

# 启用字体配置
sudo eselect fontconfig enable 40-nonlatin.conf
sudo eselect fontconfig enable 45-latin.conf
sudo eselect fontconfig enable 50-user.conf
sudo eselect fontconfig enable 60-latin.conf
sudo eselect fontconfig enable 65-nonlatin.conf

# 刷新字体缓存
eselect fontconfig list
fc-cache -rv

# 更新环境变量
sudo env-update && . /etc/profile
