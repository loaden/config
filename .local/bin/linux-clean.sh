#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

sudo journalctl --vacuum-size 50M

if [ -f /bin/apt ]; then
    sudo apt purge $(dpkg-query -W -f'${Package}\n' 'linux-*' | sed -nr 's/.*-([0-9]+(\.[0-9]+){2}-[^-]+).*/\1 &/p' | linux-version sort | awk '($1==c){exit} {print $2}' c=$(uname -r | cut -f1,2 -d-))
    sudo apt autopurge -y
    sudo apt clean
fi

if [ -f /bin/dnf ]; then
    sudo sed -i 's/installonly_limit=3/installonly_limit=2/g' /etc/dnf/dnf.conf
    sudo pkcon refresh force -c -1
    sudo dnf autoremove -y
    sudo dnf system-upgrade clean
    sudo dnf clean packages
    sudo dnf clean all
fi
