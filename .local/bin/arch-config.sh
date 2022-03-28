#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

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

# 软件源
sudo pacman -Syy
sudo pacman -S reflector --noconfirm --needed
sudo reflector -c china --protocol https,http --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist --connection-timeout 2 --download-timeout 2
cat /etc/pacman.d/mirrorlist
sudo perl -0777 -pi -e 's/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
[[ ! $(cat /etc/pacman.conf | grep archlinuxcn) ]] && sudo bash -c 'echo -e "\n[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch\nServer = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch" >> /etc/pacman.conf'
sudo pacman -Syy
sudo pacman -S archlinuxcn-keyring --noconfirm --needed
sudo pacman -S archlinux-keyring --noconfirm --needed

# 中文
sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo sed -i 's/# zh_CN.UTF-8/zh_CN.UTF-8/g' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=zh_CN.UTF-8

# 配置默认终端
sudo chsh -s /bin/bash $USER

# 电源管理
sudo pacman -S --noconfirm --needed acpid thermald
sudo systemctl enable acpid.service
sudo systemctl enable thermald.service

# udisks 支持 NTFS3
sudo bash -c 'echo -e "[defaults]\nntfs_defaults=uid=$SUDO_UID,gid=$SUDO_GID,noatime,prealloc" > /etc/udisks2/mount_options.conf'

# 重载UDEV规则
sudo udevadm control --reload
sudo udevadm trigger

# 别名
if [ -z "$(grep .bash_aliases ~/.bashrc)" ]; then
    echo "[ -f ~/.bash_aliases ] && . ~/.bash_aliases" >> ~/.bashrc
fi

# 夜灯
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3000
gsettings set org.gnome.settings-daemon.plugins.color night-light-last-coordinates "(36.0649,120.3804)"

# 文本编译器
gsettings set org.gnome.gedit.preferences.editor use-default-font false
gsettings set org.gnome.gedit.preferences.editor editor-font 'Monospace 12'
gsettings set org.gnome.gedit.preferences.editor highlight-current-line false
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor search-highlighting true
gsettings set org.gnome.gedit.plugins active-plugins ['spell', 'sort', 'quickhighlight', 'openlinks', 'filebrowser', 'docinfo']

# 刷新字体缓存
fc-cache -rv

# 搞定
read -p "DONE!" -n 1
