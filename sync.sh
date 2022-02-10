#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# etc
cp -r /etc/portage/make.conf etc/portage/make.conf
cp -r /etc/portage/repos.conf/ etc/portage/
cp -r /etc/portage/package.accept_keywords/ etc/portage/
cp -r /etc/portage/package.accept_keywords/ package.use
cp -r /etc/portage/package.mask/ etc/portage/
cp -r /etc/portage/package.use/ etc/portage/

# var
sudo cat /var/lib/portage/world > var/lib/portage/world

# usr
cp /usr/src/linux/.config usr/src/linux/
