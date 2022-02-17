#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# portage
[ -d /etc/portage/ ] && rm -rf etc/portage/
mkdir -p etc/portage
cp /etc/portage/make.conf etc/portage/make.conf
cp -r /etc/portage/package.accept_keywords/ etc/portage/
rm -f etc/portage/package.accept_keywords/zz-*
cp -r /etc/portage/package.mask/ etc/portage/
cp -r /etc/portage/package.use/ etc/portage/
rm -f etc/portage/package.use/zz-*

# dracut
[ -d /etc/dracut.conf.d/ ] && rm -rf etc/dracut.conf.d/
mkdir -p etc/dracut.conf.d/
cp -r /etc/dracut.conf.d/ etc/

# kernel config
cp /usr/src/linux/.config usr/src/linux/
cp /usr/src/linux/.config.*.* usr/src/linux/

# mnt kernel config
[ -d /mnt/gentoo/ ] && cp /mnt/gentoo/usr/src/linux/.config.*.* usr/src/linux/

# else
[ -f /var/lib/portage/world ] && sudo cat /var/lib/portage/world > var/lib/portage/world
