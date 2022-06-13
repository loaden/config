#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 启动单元初始化配置
sudo systemd-firstboot --setup-machine-id
sudo systemctl preset-all --preset-mode=enable-only

# 网络
sudo systemctl disable --now systemd-networkd.socket systemd-networkd.service
# sudo systemctl disable --now systemd-resolved.service
sudo systemctl enable --now NetworkManager.service

# 主机名
HOSTNAME=lucky
sudo hostnamectl hostname $HOSTNAME
if [[ -z $(grep $HOSTNAME /etc/hosts) ]]; then
    sudo HOSTNAME=$HOSTNAME bash -c 'echo -e "\n127.0.0.1\t$HOSTNAME.me $HOSTNAME\n" >> /etc/hosts'
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

# 允许弱密码
sudo sed -i 's/enforce=everyone/enforce=none/g' /etc/security/passwdqc.conf

# 配置默认终端
sudo chsh -s /bin/bash $USER

# 电源管理
sudo systemctl enable acpid.service
sudo systemctl enable thermald.service

# 用户组
sudo usermod -aG audio,video $USER
sudo usermod -aG lpadmin $USER
#sudo usermod -aG scanner $USER
sudo usermod -aG pcap $USER

# 支持NTFS3
sudo bash -c 'echo -e "[defaults]\nntfs_defaults=uid=0,gid=0,noatime,prealloc" > /etc/udisks2/mount_options.conf'

# wheel用户组授权polkit
sudo bash -c 'echo -e "polkit.addAdminRule(function(action, subject) {\n    return ["unix-group:wheel"];\n});" > /etc/polkit-1/rules.d/10-admin.rules'
sudo systemctl restart polkit.service

# 蓝牙
# sudo systemctl enable bluetooth --now
# bluetoothctl list

# 配置中国用户源和官方GURU源
sudo emerge -avu1 eselect-repository
sudo eselect repository enable gentoo-zh >/dev/null
# sudo eselect repository enable guru >/dev/null
sudo eselect repository disable guru >/dev/null
# emerge --sync


########################################################
# 从现在开始仅允许普通用户权限执行                     #
########################################################
if [ $EUID == 0 ]; then
    echo $(basename $0) 命令从现在开始只允许普通用户执行
    exit 1
fi

# 用户目录
sudo emerge -avu1 xdg-user-dirs
xdg-user-dirs-update --force

# 别名
if [ -z "$(grep .bash_aliases ~/.bashrc)" ]; then
    echo "[ -f ~/.bash_aliases ] && . ~/.bash_aliases" >> ~/.bashrc
fi

# 删除用户服务目录
rm -rf ~/.config/systemd

# PipeWire替代PulseAudio
sudo sed -i 's/.*autospawn =.*/autospawn = no/g' /etc/pulse/client.conf
sudo sed -i 's/.*daemonize =.*/daemonize = no/g' /etc/pulse/daemon.conf
systemctl --user disable --now pulseaudio.service pulseaudio.socket
systemctl --user enable --now pipewire.socket pipewire-pulse.socket
systemctl --user daemon-reload
LANG=C pactl info | grep "Server Name"

# PipeWire更换session服务
systemctl --user disable --now pipewire-media-session.service
systemctl --user enable --now --force wireplumber.service

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
