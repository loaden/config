#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 仅允许普通用户权限执行
if [ $EUID == 0 ]; then
    echo $(basename $0) 命令只允许普通用户执行
    exit 1
fi

# portage
[ -d /etc/portage/ ] && rm -rf etc/portage/
mkdir -p etc/portage
cp /etc/portage/make.conf etc/portage/
cp -r /etc/portage/package.accept_keywords/ etc/portage/
echo "# Hi..." > etc/portage/package.accept_keywords/zz-autounmask
cp -r /etc/portage/package.mask/ etc/portage/
cp -r /etc/portage/package.use/ etc/portage/
echo "# Hi..." > etc/portage/package.use/zz-autounmask
cp -r /etc/portage/env/ etc/portage/
cp /etc/portage/package.env etc/portage/

# dracut
[ -d /etc/dracut.conf.d/ ] && rm -rf etc/dracut.conf.d/
mkdir -p etc/dracut.conf.d/
cp -r /etc/dracut.conf.d/ etc/

# kernel config
cp /usr/src/linux/.config usr/src/linux/
cp /usr/src/linux/.config.*.* usr/src/linux/

# mnt kernel config
[ -d /mnt/gentoo/ ] && cp /mnt/gentoo/usr/src/linux/.config.*.* usr/src/linux/

# ccache
[ -f /etc/ccache.conf ] && cp /etc/ccache.conf etc/

# else
[ -f /var/lib/portage/world ] && sudo cat /var/lib/portage/world > var/lib/portage/world
