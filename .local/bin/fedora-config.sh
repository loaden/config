#!/bin/bash
# 维护：Yuchen Deng QQ群：19346666、111601117

# 确认管理员权限
if [ $UID != 0 -o ”$SUDO_USER“ == "root" ]; then
    echo "请打开终端，在脚本前添加 sudo 执行，或者 sudo -s 获得管理员权限后再执行。"
    exit 1
fi

cat > /etc/yum.repos.d/fedora.repo <<EOF
[fedora]
name=Fedora \$releasever - \$basearch
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/\$releasever/Everything/\$basearch/os/
metadata_expire=28d
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
EOF

cat > /etc/yum.repos.d/fedora-updates.repo <<EOF
[updates]
name=Fedora \$releasever - \$basearch - Updates
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/updates/\$releasever/Everything/\$basearch/
enabled=1
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
EOF

cat > /etc/yum.repos.d/fedora-modular.repo <<EOF
[fedora-modular]
name=Fedora Modular \$releasever - \$basearch
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/\$releasever/Modular/\$basearch/os/
enabled=1
metadata_expire=7d
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
EOF

cat > /etc/yum.repos.d/fedora-updates-modular.repo <<EOF
[updates-modular]
name=Fedora Modular \$releasever - \$basearch - Updates
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/updates/\$releasever/Modular/\$basearch/
enabled=1
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
EOF

dnf makecache
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install code -y

sudo dnf install bash-completion -y  #终端自动完成
sudo dnf install fdupes -y #重复文件查找
sudo dnf install flatpak -y  #Flatpak
sudo dnf install git -y #版本管理
sudo dnf install gnome-extensions-app -y
sudo dnf install gnome-shell-extension-dash-to-dock -y
sudo dnf install gnome-shell-extension-topicons-plus -y
sudo dnf install gnome-tweaks -y
sudo dnf install gparted -y #分区编辑器
sudo dnf install htop -y #进程查看器
sudo dnf install neofetch -y #系统信息
sudo dnf install openssh-server -y #远程连接
sudo dnf install system-config-printer -y  #打印机管理
sudo dnf install telnet -y #远程访问
sudo dnf install traceroute -y #路由跟踪
sudo dnf install tree -y #树
sudo dnf install unar -y #解压缩
sudo dnf install zstd -y #最快解压
sudo dnf remove libreoffice-core -y
sudo dnf remove rhythmbox -y
sudo systemctl enable sshd

