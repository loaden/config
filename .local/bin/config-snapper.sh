#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

# 确认普通用户执行
if [ $EUID = 0 ]; then
    echo "请用普通用户身份执行"
    exit 1
fi

# 普通用户子卷
function create_user_subvolume()
{
    [ -z $1 ] && echo empty arg '$1' && return
    [ -L $1 ] && return
    if [[ `stat --format=%i $1` -ne 256 && `stat --format=%i $1` -ne 1 ]]; then
        mv $1 $1.bak
        btrfs subvolume create $1
        mv $1.bak/* $1/
        [ $? -eq 0 ] && rm -r $1.bak
    fi
}

# 管理员子卷
function create_root_subvolume()
{
    [ -z $1 ] && echo empty arg '$1' && return
    [ -L $1 ] && return
    if [[ `stat --format=%i $1` -ne 256 && `stat --format=%i $1` -ne 1 ]]; then
        sudo mv $1 $1.bak
        sudo btrfs subvolume create $1
        sudo mv $1.bak/* $1/
        [ $? -eq 0 ] && sudo rm -r $1.bak
    fi
}

# 配置
create_user_subvolume $HOME/.config

# 主目录缓存
#create_user_subvolume $HOME/.cache

# 用户flatpak
create_user_subvolume $HOME/.local/share/flatpak
create_user_subvolume $HOME/.var

# 系统flatpak
create_root_subvolume /var/lib/flatpak

# 日志
create_root_subvolume /var/log

# 包缓存
[ -d /var/cache/apt/archives ] && create_root_subvolume /var/cache/apt/archives
[ -d /var/cache/pacman/pkg ] && create_root_subvolume /var/cache/pacman/pkg

# 系统临时文件
create_root_subvolume /var/tmp
create_root_subvolume /tmp
sudo chmod 1777 /var/tmp
sudo chmod 1777 /tmp

# 容器
[ `stat --format=%i $HOME/.machines` -ne 256 ] && echo $(machinectl | grep container |  awk '{print $ 1}') | xargs machinectl stop
create_root_subvolume $HOME/.machines

# 提速
[ -f /etc/updatedb.conf ] && sudo sed -i 's/.*PRUNENAMES=.*/PRUNENAMES=".git .snapshots .machines .cache .var flatpak"/' /etc/updatedb.conf

# 查询
sudo btrfs subvolume list -p / | grep -v .snapshots

# 安装snapper
[[ -f /bin/apt && ! -f /bin/snapper ]] && sudo apt install snapper -y
[[ -f /bin/pacman && ! -f /bin/snapper ]] && sudo pacman -S snapper --noconfirm
[[ -f /bin/dnf && ! -f /bin/snapper ]] && sudo dnf install snapper -y

# snapper配置
[ -f /etc/default/snapper ] && sudo sed -i 's/.*DISABLE_APT_SNAPSHOT=.*/DISABLE_APT_SNAPSHOT="yes"/' /etc/default/snapper
[ ! -f /etc/snapper/configs/root ] && sudo snapper create-config /
if [ ! -f /etc/snapper/configs/home ]; then
    if [[ ! -d /home/.snapshots || `stat --format=%i /home/.snapshots` -ne 256 ]]; then
        sudo rm -rf /home/.snapshots
        [ -f /etc/sysconfig/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/sysconfig/snapper
        [ -f /etc/default/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/default/snapper
        [ -f /etc/conf.d/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/conf.d/snapper
        sudo snapper -c home create-config /home
    else
        sudo cp /etc/snapper/configs/root /etc/snapper/configs/home
        sudo sed -i 's/SUBVOLUME=.*/SUBVOLUME="\/home"/' /etc/snapper/configs/home
        [ -f /etc/sysconfig/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root home"/' /etc/sysconfig/snapper
        [ -f /etc/default/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root home"/' /etc/default/snapper
        [ -f /etc/conf.d/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root home"/' /etc/conf.d/snapper
        sudo snapper -c home create-config /home 2>/dev/null
        sleep 1
    fi
fi

# 配置
sudo snapper list-configs
sudo snapper list -a
sudo snapper set-config FREE_LIMIT=2g
sudo snapper -c home set-config FREE_LIMIT=2g
sudo snapper set-config ALLOW_USERS=$USER
sudo snapper -c home set-config ALLOW_USERS=$USER
sudo snapper set-config TIMELINE_CREATE=yes
sudo snapper -c home set-config TIMELINE_CREATE=yes
sudo snapper set-config TIMELINE_CLEANUP=yes
sudo snapper -c home set-config TIMELINE_CLEANUP=yes
sudo snapper set-config TIMELINE_LIMIT_HOURLY=5
sudo snapper -c home set-config TIMELINE_LIMIT_HOURLY=5
sudo snapper set-config TIMELINE_LIMIT_DAILY=7
sudo snapper -c home set-config TIMELINE_LIMIT_DAILY=7
sudo snapper set-config TIMELINE_LIMIT_WEEKLY=0
sudo snapper -c home set-config TIMELINE_LIMIT_WEEKLY=0
sudo snapper set-config TIMELINE_LIMIT_MONTHLY=0
sudo snapper -c home set-config TIMELINE_LIMIT_MONTHLY=0
sudo snapper set-config TIMELINE_LIMIT_YEARLY=0
sudo snapper -c home set-config TIMELINE_LIMIT_YEARLY=0
sudo snapper set-config TIMELINE_MIN_AGE=1800
sudo snapper -c home set-config TIMELINE_MIN_AGE=1800
sudo snapper set-config EMPTY_PRE_POST_CLEANUP=yes
sudo snapper -c home set-config EMPTY_PRE_POST_CLEANUP=yes
sudo snapper set-config NUMBER_LIMIT=15
sudo snapper -c home set-config NUMBER_LIMIT=20
sudo snapper set-config NUMBER_LIMIT_IMPORTANT=5
sudo snapper -c home set-config NUMBER_LIMIT_IMPORTANT=5
sudo btrfs quota disable /
sudo btrfs quota disable /home

# 启用定时快照
if [[ -z $(systemctl status snapper-timeline.timer 2>/dev/null |grep '; enabled;') ]]; then
    sudo systemctl enable snapper-timeline.timer
    sudo systemctl start snapper-timeline.timer
fi

# 禁用启动快照
if [[ -n $(systemctl status snapper-boot.timer 2>/dev/null |grep '; enabled;') ]]; then
    sudo systemctl disable snapper-boot.timer
    sudo systemctl stop snapper-boot.timer
fi

# 启用自动清理
if [[ -z $(systemctl status snapper-cleanup.timer 2>/dev/null |grep '; enabled;') ]]; then
    sudo systemctl enable snapper-cleanup.timer
    sudo systemctl start snapper-cleanup.timer
fi

