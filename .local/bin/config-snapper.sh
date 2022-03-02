#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 确认普通用户执行
if [ $EUID = 0 ]; then
    echo "请用普通用户身份执行"
    exit 1
fi

# 是否启用家目录还原
is_home_snapper=0

# 普通用户子卷
function create_user_subvolume()
{
    [ -z $1 ] && echo empty arg '$1' && return
    [ -L $1 ] && return

    if [ "$is_home_snapper" = "0" ]; then
        if ! [[ `stat --format=%i $1` -ne 256 && `stat --format=%i $1` -ne 1 ]]; then
            mkdir $1.bak
            mv $1/* $1.bak/
            sudo btrfs subvolume delete $1
            mv $1.bak $1
        fi
        return
    fi

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
create_user_subvolume $HOME/.cache

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
if [ "$is_home_snapper" = "0" ]; then
    sudo rm -rf /home/.snapshots
    [ -f /etc/sysconfig/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/sysconfig/snapper
    [ -f /etc/default/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/default/snapper
    [ -f /etc/conf.d/snapper ] && sudo sed -i 's/SNAPPER_CONFIGS=.*/SNAPPER_CONFIGS="root"/' /etc/conf.d/snapper
else
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
fi

# 配置
sudo snapper list-configs
sudo snapper list -a
sudo snapper set-config FREE_LIMIT=2g
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config FREE_LIMIT=2g
sudo snapper set-config ALLOW_USERS=$USER
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config ALLOW_USERS=$USER
sudo snapper set-config TIMELINE_CREATE=yes
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_CREATE=yes
sudo snapper set-config TIMELINE_CLEANUP=yes
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_CLEANUP=yes
sudo snapper set-config TIMELINE_LIMIT_HOURLY=5
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_LIMIT_HOURLY=5
sudo snapper set-config TIMELINE_LIMIT_DAILY=7
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_LIMIT_DAILY=7
sudo snapper set-config TIMELINE_LIMIT_WEEKLY=0
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_LIMIT_WEEKLY=0
sudo snapper set-config TIMELINE_LIMIT_MONTHLY=0
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_LIMIT_MONTHLY=0
sudo snapper set-config TIMELINE_LIMIT_YEARLY=0
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_LIMIT_YEARLY=0
sudo snapper set-config TIMELINE_MIN_AGE=1800
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config TIMELINE_MIN_AGE=1800
sudo snapper set-config EMPTY_PRE_POST_CLEANUP=yes
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config EMPTY_PRE_POST_CLEANUP=yes
sudo snapper set-config NUMBER_LIMIT=15
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config NUMBER_LIMIT=20
sudo snapper set-config NUMBER_LIMIT_IMPORTANT=5
[ "$is_home_snapper" = "0" ] || sudo snapper -c home set-config NUMBER_LIMIT_IMPORTANT=5
sudo btrfs quota disable /
[ "$is_home_snapper" = "0" ] || sudo btrfs quota disable /home

# 禁用定时快照
if [ "$(systemctl is-enabled snapper-timeline.timer)" = "enabled" ]; then
    sudo systemctl disable snapper-timeline.timer
    sudo systemctl stop snapper-timeline.timer
fi

# 启用启动快照
if [ "$(systemctl is-enabled snapper-boot.timer)" = "disabled" ]; then
    sudo systemctl enable snapper-boot.timer
    sudo systemctl start snapper-boot.timer
fi

# 启用自动清理
if [ "$(systemctl is-enabled snapper-cleanup.timer)" = "disabled" ]; then
    sudo systemctl enable snapper-cleanup.timer
    sudo systemctl start snapper-cleanup.timer
fi
