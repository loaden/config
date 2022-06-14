#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

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

# 系统flatpak
create_root_subvolume /var/lib/flatpak

# 日志
create_root_subvolume /var/log

# 查询
sudo btrfs subvolume list -p / | grep -v .snapshots

# snapper配置
[ ! -f /etc/snapper/configs/root ] && sudo snapper create-config /

# 配置
sudo snapper list-configs
sudo snapper list -a
sudo snapper set-config ALLOW_GROUPS=wheel
sudo snapper set-config SYNC_ACL=yes
sudo snapper set-config FREE_LIMIT=2g
sudo snapper set-config TIMELINE_CREATE=yes
sudo snapper set-config TIMELINE_MIN_AGE=1200
sudo snapper set-config TIMELINE_CLEANUP=yes
sudo snapper set-config TIMELINE_LIMIT_HOURLY=3
sudo snapper set-config TIMELINE_LIMIT_DAILY=7
sudo snapper set-config TIMELINE_LIMIT_WEEKLY=3
sudo snapper set-config TIMELINE_LIMIT_MONTHLY=0
sudo snapper set-config TIMELINE_LIMIT_YEARLY=0
sudo snapper set-config NUMBER_CLEANUP=yes
sudo snapper set-config NUMBER_MIN_AGE=1200
sudo snapper set-config NUMBER_LIMIT=10
sudo snapper set-config NUMBER_LIMIT_IMPORTANT=3
sudo snapper set-config EMPTY_PRE_POST_CLEANUP=yes
sudo btrfs qgroup show /
sudo btrfs quota disable /
sudo btrfs subvolume list -s / | wc -l

# 启用定时快照
if [ "$(systemctl is-enabled snapper-timeline.timer)" = "disabled" ]; then
    sudo systemctl enable snapper-timeline.timer
    sudo systemctl start snapper-timeline.timer
fi

# 禁用启动快照
if [ "$(systemctl is-enabled snapper-boot.timer)" = "enabled" ]; then
    sudo systemctl disable snapper-boot.timer
    sudo systemctl stop snapper-boot.timer
fi

# 启用自动清理
if [ "$(systemctl is-enabled snapper-cleanup.timer)" = "disabled" ]; then
    sudo systemctl enable snapper-cleanup.timer
    sudo systemctl start snapper-cleanup.timer
fi
