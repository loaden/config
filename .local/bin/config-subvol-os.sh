#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 确认管理员权限
if [[ $EUID != 0 ]]; then
    echo "请打开终端，在脚本前添加 sudo 后执行。"
    exit 1
fi

dest_subvol="elementary debian ubuntu fedora arch"
efi_part=/dev/sda1
btrfs_part=/dev/sda2

[[ $(ls /mnt) ]] && umount -R -l /mnt
[ -d /boot/efi/EFI ] && umount /boot/efi

for i in $dest_subvol; do
    echo
    echo "Start config '$i'..."

    mount -o subvol=@$i $btrfs_part /mnt
    mount $efi_part /mnt/boot/efi
    mount --bind /dev /mnt/dev
    mount --bind /dev/pts /mnt/dev/pts
    mount --bind /proc /mnt/proc
    mount --bind /sys /mnt/sys
    mount --bind /run /mnt/run

    if [[ `stat --format=%i /mnt/tmp` -eq 256 ]]; then
        btrfs subvolume delete /mnt/tmp
        rm -rf /mnt/tmp
        mkdir -pv /mnt/tmp
        chmod 1777 /mnt/tmp /mnt/var/tmp
    fi

    cat > /mnt/config.sh <<EOF
        [[ -z "$(nmcli dev show | grep DNS)" ]] && echo "Cannot reach DNS resolv." && exit

        mv /etc/default/grub /etc/default/grub.bak

        if [ -f /bin/apt ]; then
            rm -f /var/lib/dpkg/lock-frontend
            rm -f /var/lib/dpkg/lock
            rm -f /var/cache/apt/archives/lock
            dpkg --configure -a
            apt install -f
            apt purge grub-common --allow-remove-essential -y
            apt install grub-efi -y
            apt autopurge -y
        fi

        if [ -f /bin/pacman ]; then
            pacman -Rsc grub  --noconfirm
            pacman -S grub --noconfirm
        fi

        if [ ! -f /etc/default/grub ]; then
            echo -e "\033[31m\nOops! Does not generate /etc/default/grub for '$i'"
            echo -e "\033[0m"
            mv /etc/default/grub.bak /etc/default/grub
        else
            rm /etc/default/grub.bak
        fi

        sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=0/' /etc/default/grub
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
        sed -i 's/.*GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
        sed -i 's/.*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=true/' /etc/default/grub
        sed -i 's/.*GRUB_FORCE_HIDDEN_MENU=.*/GRUB_FORCE_HIDDEN_MENU=true/' /etc/default/grub
        sed -i 's/.*GRUB_HIDDEN_TIMEOUT=.*/GRUB_HIDDEN_TIMEOUT=1/' /etc/default/grub
        sed -i 's/.*GRUB_HIDDEN_TIMEOUT_QUIET=.*/GRUB_HIDDEN_TIMEOUT_QUIET=true/' /etc/default/grub
        [[ ! \$(cat /etc/default/grub |grep GRUB_TIMEOUT_STYLE=) ]] && echo "GRUB_TIMEOUT_STYLE=hidden" >> /etc/default/grub
        [[ ! \$(cat /etc/default/grub |grep GRUB_DISABLE_OS_PROBER=) ]] && echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub
        [[ ! \$(cat /etc/default/grub |grep GRUB_FORCE_HIDDEN_MENU=) ]] && echo "GRUB_FORCE_HIDDEN_MENU=true" >> /etc/default/grub
        [[ ! \$(cat /etc/default/grub |grep GRUB_HIDDEN_TIMEOUT=) ]] && echo "GRUB_HIDDEN_TIMEOUT=1" >> /etc/default/grub
        [[ ! \$(cat /etc/default/grub |grep GRUB_HIDDEN_TIMEOUT_QUIET=) ]] && echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub
        cat /etc/default/grub | grep "^GRUB_"

        if [[ "$i" == "elementary" ]]; then
            echo grub-install for elementary...
            grub-install --efi-directory=/boot/efi --bootloader-id=ElementaryOS --no-uefi-secure-boot
        elif [[ "$i" == "fedora" ]]; then
            echo grub-install for fedora...
            rm -f /boot/efi/EFI/fedora/grub.cfg
            rm -f /boot/grub2/grub.cfg
            dnf reinstall grub2* -y
            sleep 2
            if [[ -z \$(efibootmgr | egrep -i fedora) ]]; then
                echo -e "\033[31m\nWHAT THE FUCK!\033[0m"
                efibootmgr -c -L fedora -l "\EFI\fedora\shimx64.efi"
            fi
        else
            grub-install
        fi

        [ -d /boot/grub ] && grub-mkconfig -o /boot/grub/grub.cfg
        [ -d /boot/grub2 ] && grub2-mkconfig -o /boot/grub2/grub.cfg
EOF

    [ -f /mnt/etc/resolv.conf ] && cp /mnt/etc/resolv.conf /mnt/etc/resolv.conf.bak
    cp /etc/resolv.conf /mnt/etc/resolv.conf
    sleep 1
    chroot /mnt /bin/bash /config.sh
    rm -f /mnt/etc/resolv.conf
    [ -f /mnt/etc/resolv.conf.bak ] && mv /mnt/etc/resolv.conf.bak /mnt/etc/resolv.conf

    cat > /mnt/etc/fstab <<EOF
# <file system>  <mount point>  <type>  <options>      <dump>  <pass>
PARTLABEL=efi    /boot/efi      vfat    umask=0077     0       0
PARTLABEL=btrfs  /              btrfs   noatime,subvol=@debian,compress=zstd:1,discard=async,ssd  0  0
PARTLABEL=btrfs  /home          btrfs   noatime,subvol=@home,compress=zstd:1,discard=async,ssd    0  0
PARTLABEL=btrfs  /swap          btrfs   subvol=@swap   0       0
/swap/swapfile   none           swap    sw             0       0
EOF
    sed -i "s/debian/$i/" /mnt/etc/fstab
    [[ ${#i} != 6 ]] && nano /mnt/etc/fstab

    rm /mnt/config.sh
    umount -R -l /mnt
    sleep 1
done

[ ! -d /boot/efi/EFI ] && mount $efi_part /boot/efi
ls /boot/efi/EFI
efibootmgr -v
