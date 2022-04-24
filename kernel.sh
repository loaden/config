#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 确认管理员权限
if [[ $EUID != 0 ]]; then
    echo "请打开终端，在脚本前添加 sudo 执行，或者 sudo -s 获得管理员权限后再执行。"
    exit 1
fi

# 拷贝后执行副本，预防修改后错乱
if [ "$0" != "/etc/$(basename $0)" ]; then
    cp -f $0 /etc/$(basename $0)
    bash /etc/$(basename $0)
    exit 0
fi

cd /usr/src/linux

# 启用Clang编译内核
BUILD_WITH_CLANG=0

# 初始本地配置
read -p "是否生成本地配置？[y/N/old]" choice
case $choice in
YES | yes | Y | y) mv .config .config.bak && make localmodconfig && sleep 1 ;;
OLD | old | O | o) make oldconfig && sleep 1 ;;
N | n | '') true ;;
*) echo 错误选择，程序意外退出！ && exit ;;
esac

# 启用Clang薄LTO优化
if [ "$BUILD_WITH_CLANG" = "1" ]; then
    export LLVM=1
    scripts/config -e CONFIG_LTO_CLANG_THIN
else
    scripts/config --set-val CONFIG_CLANG_VERSION "0"
fi

# 通用设置
scripts/config  \
                --set-str CONFIG_DEFAULT_HOSTNAME "(none)" \
                --set-str CONFIG_LOCALVERSION "" \
                -d CONFIG_HYPERVISOR_GUEST \
                -d CONFIG_MODULE_FORCE_LOAD \
                -d CONFIG_PRINTK_INDEX \
                -d CONFIG_X86_X32 \
                -d MICROCODE \
                -e CONFIG_CHECKPOINT_RESTORE \
                -e CONFIG_HIBERNATION \
                -e CONFIG_IKCONFIG_PROC \
                -m CONFIG_IKCONFIG \

# Gentoo配置
scripts/config  -d CONFIG_GENTOO_LINUX_INIT_SCRIPT \
                -e CONFIG_GENTOO_LINUX_INIT_SYSTEMD \

# 精简
scripts/config  \
                -d CONFIG_ACPI_WMI \
                -d CONFIG_ACRN_GUEST \
                -d CONFIG_AGP_INTEL \
                -d CONFIG_ANDROID \
                -d CONFIG_ARCH_CPUIDLE_HALTPOLL \
                -d CONFIG_AX88796B_PHY \
                -d CONFIG_BOOT_PRINTK_DELAY \
                -d CONFIG_CFG80211 \
                -d CONFIG_CHROME_PLATFORMS \
                -d CONFIG_CRYPTO_842 \
                -d CONFIG_CRYPTO_LIB_ARC4 \
                -d CONFIG_CRYPTO_LZ4HC \
                -d CONFIG_CRYPTO_LZO \
                -d CONFIG_CRYPTO_USER \
                -d CONFIG_DEBUG_BOOT_PARAMS \
                -d CONFIG_DEBUG_INFO \
                -d CONFIG_DEBUG_LIST \
                -d CONFIG_DEBUG_SHIRQ \
                -d CONFIG_DETECT_HUNG_TASK \
                -d CONFIG_DRM_AMDGPU \
                -d CONFIG_DRM_DEBUG_MM \
                -d CONFIG_DRM_RADEON \
                -d CONFIG_DRM_VIRTIO_GPU \
                -d CONFIG_FB_INTEL \
                -d CONFIG_HARDLOCKUP_DETECTOR \
                -d CONFIG_HMM_MIRROR \
                -d CONFIG_I2C_MUX \
                -d CONFIG_INET_TUNNEL \
                -d CONFIG_INIT_STACK_ALL_ZERO \
                -d CONFIG_INPUT_JOYDEV \
                -d CONFIG_INPUT_JOYSTICK \
                -d CONFIG_INPUT_MOUSEDEV \
                -d CONFIG_INPUT_TOUCHSCREEN \
                -d CONFIG_INPUT_UINPUT \
                -d CONFIG_IPMI_HANDLER \
                -d CONFIG_IP_NF_IPTABLES \
                -d CONFIG_ISDN \
                -d CONFIG_JAILHOUSE_GUEST \
                -d CONFIG_KALLSYMS_ALL \
                -d CONFIG_KEXEC_JUMP \
                -d CONFIG_KEY_DH_OPERATIONS \
                -d CONFIG_KVM_INTEL \
                -d CONFIG_KVM_XEN \
                -d CONFIG_LATENCYTOP \
                -d CONFIG_MAC_EMUMOUSEBTN \
                -d CONFIG_MANAGER_SBS \
                -d CONFIG_MEDIA_ANALOG_TV_SUPPORT \
                -d CONFIG_MEDIA_TUNER \
                -d CONFIG_MEDIA_TUNER_TEA5761 \
                -d CONFIG_MEDIA_TUNER_TEA5767 \
                -d CONFIG_MELLANOX_PLATFORM \
                -d CONFIG_MFD_INTEL_PMC_BXT \
                -d CONFIG_MTD \
                -d CONFIG_NETFILTER_XTABLES \
                -d CONFIG_NET_FC \
                -d CONFIG_NET_IPIP \
                -d CONFIG_NET_IP_TUNNEL \
                -d CONFIG_NET_VENDOR_3COM \
                -d CONFIG_NET_VENDOR_ADAPTEC \
                -d CONFIG_NET_VENDOR_AGERE \
                -d CONFIG_NET_VENDOR_ALACRITECH \
                -d CONFIG_NET_VENDOR_ALTEON \
                -d CONFIG_NET_VENDOR_AMAZON \
                -d CONFIG_NET_VENDOR_AMD \
                -d CONFIG_NET_VENDOR_AQUANTIA \
                -d CONFIG_NET_VENDOR_ARC \
                -d CONFIG_NET_VENDOR_ATHEROS \
                -d CONFIG_NET_VENDOR_BROADCOM \
                -d CONFIG_NET_VENDOR_BROCADE \
                -d CONFIG_NET_VENDOR_CADENCE \
                -d CONFIG_NET_VENDOR_CAVIUM \
                -d CONFIG_NET_VENDOR_CHELSIO \
                -d CONFIG_NET_VENDOR_CISCO \
                -d CONFIG_NET_VENDOR_CORTINA \
                -d CONFIG_NET_VENDOR_DEC \
                -d CONFIG_NET_VENDOR_DLINK \
                -d CONFIG_NET_VENDOR_EMULEX \
                -d CONFIG_NET_VENDOR_EZCHIP \
                -d CONFIG_NET_VENDOR_GOOGLE \
                -d CONFIG_NET_VENDOR_HUAWEI \
                -d CONFIG_NET_VENDOR_INTEL \
                -d CONFIG_NET_VENDOR_LITEX \
                -d CONFIG_NET_VENDOR_MARVELL \
                -d CONFIG_NET_VENDOR_MELLANOX \
                -d CONFIG_NET_VENDOR_MICREL \
                -d CONFIG_NET_VENDOR_MICROCHIP \
                -d CONFIG_NET_VENDOR_MICROSEMI \
                -d CONFIG_NET_VENDOR_MICROSOFT \
                -d CONFIG_NET_VENDOR_MYRI \
                -d CONFIG_NET_VENDOR_NATSEMI \
                -d CONFIG_NET_VENDOR_NETERION \
                -d CONFIG_NET_VENDOR_NETRONOME \
                -d CONFIG_NET_VENDOR_NI \
                -d CONFIG_NET_VENDOR_NVIDIA \
                -d CONFIG_NET_VENDOR_OKI \
                -d CONFIG_NET_VENDOR_PACKET_ENGINES \
                -d CONFIG_NET_VENDOR_PENSANDO \
                -d CONFIG_NET_VENDOR_QLOGIC \
                -d CONFIG_NET_VENDOR_QUALCOMM \
                -d CONFIG_NET_VENDOR_RDC \
                -d CONFIG_NET_VENDOR_RENESAS \
                -d CONFIG_NET_VENDOR_ROCKER \
                -d CONFIG_NET_VENDOR_SAMSUNG \
                -d CONFIG_NET_VENDOR_SEEQ \
                -d CONFIG_NET_VENDOR_SILAN \
                -d CONFIG_NET_VENDOR_SIS \
                -d CONFIG_NET_VENDOR_SMSC \
                -d CONFIG_NET_VENDOR_SOCIONEXT \
                -d CONFIG_NET_VENDOR_SOLARFLARE \
                -d CONFIG_NET_VENDOR_STMICRO \
                -d CONFIG_NET_VENDOR_SUN \
                -d CONFIG_NET_VENDOR_SYNOPSYS \
                -d CONFIG_NET_VENDOR_TEHUTI \
                -d CONFIG_NET_VENDOR_TI \
                -d CONFIG_NET_VENDOR_VIA \
                -d CONFIG_NET_VENDOR_WIZNET \
                -d CONFIG_NET_VENDOR_XILINX \
                -d CONFIG_PARAVIRT \
                -d CONFIG_PM_GENERIC_DOMAINS \
                -d CONFIG_PVH \
                -d CONFIG_RCU_TRACE \
                -d CONFIG_SCHEDSTATS \
                -d CONFIG_SCHED_STACK_END_CHECK \
                -d CONFIG_SND_HRTIMER \
                -d CONFIG_SND_SEQUENCER \
                -d CONFIG_SOFTLOCKUP_DETECTOR \
                -d CONFIG_STAGING \
                -d CONFIG_SURFACE_PLATFORMS \
                -d CONFIG_VGA_SWITCHEROO \
                -d CONFIG_VHOST_MENU \
                -d CONFIG_VIDEO_IR_I2C \
                -d CONFIG_VIRTIO_MENU \
                -d CONFIG_VIRT_DRIVERS \
                -d CONFIG_WEXT_CORE \
                -d CONFIG_WLAN_VENDOR_ADMTEK \
                -d CONFIG_WLAN_VENDOR_ATH \
                -d CONFIG_WLAN_VENDOR_ATMEL \
                -d CONFIG_WLAN_VENDOR_BROADCOM \
                -d CONFIG_WLAN_VENDOR_CISCO \
                -d CONFIG_WLAN_VENDOR_INTEL \
                -d CONFIG_WLAN_VENDOR_INTERSIL \
                -d CONFIG_WLAN_VENDOR_MARVELL \
                -d CONFIG_WLAN_VENDOR_MICROCHIP \
                -d CONFIG_WLAN_VENDOR_QUANTENNA \
                -d CONFIG_WLAN_VENDOR_RALINK \
                -d CONFIG_WLAN_VENDOR_REALTEK \
                -d CONFIG_WLAN_VENDOR_RSI \
                -d CONFIG_WLAN_VENDOR_ST \
                -d CONFIG_WLAN_VENDOR_TI \
                -d CONFIG_WLAN_VENDOR_ZYDAS \
                -d CONFIG_X86_DECODER_SELFTEST \
                -d CONFIG_UCLAMP_TASK \
                -d CONFIG_CGROUP_RDMA \
                -d CONFIG_SLAB_MERGE_DEFAULT \
                -d CONFIG_X86_EXTENDED_PLATFORM \
                -d CONFIG_PERF_EVENTS_AMD_UNCORE \
                -d CONFIG_AMD_MEM_ENCRYPT \
                -d CONFIG_LEGACY_VSYSCALL_EMULATE \
                -d CONFIG_PM_TEST_SUSPEND \
                -d CONFIG_ACPI_DEBUG \
                -d CONFIG_CPU_IDLE_GOV_TEO \
                -d CONFIG_MODULE_FORCE_UNLOAD \
                -d CONFIG_MODULE_SRCVERSION_ALL \
                -d CONFIG_MODULE_SIG \
                -d CONFIG_OSF_PARTITION \
                -d CONFIG_UNIXWARE_DISKLABEL \
                -d CONFIG_SGI_PARTITION \
                -d CONFIG_SUN_PARTITION \
                -d CONFIG_KARMA_PARTITION \
                -d CONFIG_BINFMT_MISC \
                -d CONFIG_PAGE_IDLE_FLAG \
                -d CONFIG_PACKET_DIAG \
                -d CONFIG_UNIX_DIAG \
                -d CONFIG_IP_FIB_TRIE_STATS \
                -d CONFIG_IPV6_MIP6 \
                -d CONFIG_NET_SCH_DEFAULT \
                -d CONFIG_NET_CLS_CGROUP \
                -d CONFIG_DNS_RESOLVER \
                -d CONFIG_NETLINK_DIAG \
                -d CONFIG_PCIE_DW_PLAT_HOST \
                -d CONFIG_PCI_MESON \
                -d CONFIG_CXL_BUS \
                -d CONFIG_GOOGLE_FIRMWARE \
                -d CONFIG_CDROM \
                -d CONFIG_INTEL_MEI \
                -d CONFIG_BLK_DEV_SR \
                -d CONFIG_ATA_PIIX \
                -d CONFIG_BLK_DEV_MD \
                -d CONFIG_BLK_DEV_DM \
                -d CONFIG_MOUSE_PS2 \
                -d CONFIG_SERIO \
                -d CONFIG_SERIAL_8250_FINTEK \
                -d CONFIG_SERIAL_8250_DW \
                -d CONFIG_HW_RANDOM \
                -d CONFIG_I2C_MUX \
                -d CONFIG_SPI_AMD \
                -d CONFIG_SPI_SLAVE \
                -d CONFIG_PINCTRL_AMD \
                -d CONFIG_POWER_RESET_RESTART \
                -d CONFIG_WATCHDOG_PRETIMEOUT_GOV \
                -d CONFIG_LOGO \
                -d CONFIG_AUXDISPLAY \
                -d CONFIG_X86_PLATFORM_DRIVERS_DELL \
                -d CONFIG_SOC_TI \
                -d CONFIG_PM_DEVFREQ \
                -d CONFIG_PM_DEVFREQ \
                -d CONFIG_LIBNVDIMM \
                -d  \
                -d  \
                -d  \
                -d  \
                -d  \
                -d  \

# 精简内核调试
scripts/config  \
                --set-val CONFIG_CONSOLE_LOGLEVEL_DEFAULT "2" \
                --set-val CONFIG_MESSAGE_LOGLEVEL_DEFAULT "3" \
                -d CONFIG_DEBUG_BUGVERBOSE \
                -d CONFIG_DEBUG_FS \
                -d CONFIG_DEBUG_KERNEL \
                -d CONFIG_DEBUG_MISC \
                -d CONFIG_DEBUG_PREEMPT \
                -d CONFIG_DYNAMIC_DEBUG \
                -d CONFIG_DYNAMIC_DEBUG_CORE \
                -d CONFIG_EARLY_PRINTK \
                -d CONFIG_FTRACE \
                -d CONFIG_MAGIC_SYSRQ \
                -d CONFIG_PRINTK_TIME \
                -d CONFIG_STACKTRACE_BUILD_ID \
                -d CONFIG_STRICT_DEVMEM \
                -d CONFIG_SYMBOLIC_ERRNAME \
                -d CONFIG_X86_DEBUG_FPU \
                -d RUNTIME_TESTING_MENU \

# 压缩模式
scripts/config  \
                -d CONFIG_MODULE_COMPRESS_ZSTD \
                -d CONFIG_RD_BZIP2 \
                -d CONFIG_RD_GZIP \
                -d CONFIG_RD_LZ4 \
                -d CONFIG_RD_LZMA \
                -d CONFIG_RD_LZO \
                -d CONFIG_RD_XZ \
                -d CONFIG_ZSWAP \
                -e CONFIG_KERNEL_ZSTD \
                -e CONFIG_MODULE_COMPRESS_NONE \
                -e CONFIG_RD_ZSTD \
                -e CONFIG_ZRAM \
                -e CONFIG_ZRAM_DEF_COMP_ZSTD \

# 桌面快速响应
scripts/config  \
                -d CONFIG_NO_HZ \
                -e CONFIG_BFQ_GROUP_IOSCHED \
                -e CONFIG_HZ_1000 \
                -e CONFIG_IOSCHED_BFQ \
                -e CONFIG_NO_HZ_IDLE \
                -e CONFIG_PREEMPT \
                -e CONFIG_SCHED_AUTOGROUP \
                -e CONFIG_TICK_CPU_ACCOUNTING \

# BPF调整
scripts/config  \
                -d CONFIG_BPF_PRELOAD \
                -e CONFIG_BPF \
                -e CONFIG_BPF_JIT \
                -e CONFIG_BPF_JIT_ALWAYS_ON \
                -e CONFIG_BPF_JIT_DEFAULT_ON \
                -e CONFIG_BPF_UNPRIV_DEFAULT_OFF \
                -e CONFIG_CGROUP_BPF \
                -e CONFIG_HAVE_EBPF_JIT \

# systemd需要
scripts/config  \
                -d CONFIG_SYSFS_DEPRECATED \
                -e CONFIG_BPF_SYSCALL \
                -e CONFIG_DEVTMPFS \
                -e CONFIG_EPOLL \
                -e CONFIG_EVENTFD \
                -e CONFIG_EXPERT \
                -e CONFIG_FHANDLE \
                -e CONFIG_INOTIFY_USER \
                -e CONFIG_PROC_FS \
                -e CONFIG_SHMEM \
                -e CONFIG_SIGNALFD \
                -e CONFIG_SYSFS \
                -e CONFIG_TIMERFD \

# iwd需要
scripts/config  \
                -e CONFIG_CRYPTO_AES \
                -e CONFIG_CRYPTO_CBC \
                -e CONFIG_CRYPTO_CMAC \
                -e CONFIG_CRYPTO_DES \
                -e CONFIG_CRYPTO_ECB \
                -e CONFIG_CRYPTO_HMAC \
                -e CONFIG_CRYPTO_MD4 \
                -e CONFIG_CRYPTO_MD5 \
                -e CONFIG_CRYPTO_SHA256 \
                -e CONFIG_CRYPTO_SHA512 \
                -e CONFIG_CRYPTO_USER_API_HASH \
                -e CONFIG_CRYPTO_USER_API_SKCIPHER \
                -e CONFIG_KEY_DH_OPERATIONS \

# 虚拟机需要
scripts/config  \
                -e CONFIG_VIRTUALIZATION \
                -m CONFIG_KVM \
                -m CONFIG_VIRTIO_FS \
                -m CONFIG_VIRTIO_MEM \

# 牺牲安全性换性能
scripts/config  \
                --set-str CONFIG_CMDLINE "spectre_v1=off spectre_v2=off spec_store_bypass_disable=off pti=off" \
                -d CONFIG_HARDENED_USERCOPY \
                -d CONFIG_KEYS_REQUEST_CACHE \
                -d CONFIG_KEY_DH_OPERATIONS \
                -d CONFIG_KEY_NOTIFICATIONS \
                -d CONFIG_MQ_IOSCHED_KYBER \
                -d CONFIG_PAGE_TABLE_ISOLATION \
                -d CONFIG_PERSISTENT_KEYRINGS \
                -d CONFIG_RETPOLINE \
                -d CONFIG_SECURITY \
                -d CONFIG_SECURITYFS \
                -d CONFIG_SECURITY_DMESG_RESTRICT \
                -d CONFIG_STACKPROTECTOR \
                -d CONFIG_X86_INTEL_TSX_MODE_AUTO \
                -e CONFIG_CMDLINE_BOOL \
                -e CONFIG_X86_INTEL_TSX_MODE_ON \

# 苹果手机
scripts/config  -m CONFIG_USB_IPHETH \
                -m USB_NET_DRIVERS \

# 文件系统
scripts/config  \
                -d CONFIG_EXT4_FS_SECURITY \
                -d CONFIG_FS_ENCRYPTION \
                -d CONFIG_FS_VERITY \
                -e CONFIG_AUTOFS_FS \
                -e CONFIG_BTRFS_FS \
                -e CONFIG_BTRFS_FS_POSIX_ACL \
                -e CONFIG_EXT4_FS_POSIX_ACL \
                -e CONFIG_FAT_DEFAULT_UTF8 \
                -e CONFIG_NETWORK_FILESYSTEMS \
                -e CONFIG_NTFS3_FS_POSIX_ACL \
                -e CONFIG_NTFS3_LZX_XPRESS \
                -e CONFIG_VFAT_FS \
                -m CONFIG_CIFS \
                -m CONFIG_EXFAT_FS \
                -m CONFIG_EXT4_FS \
                -m CONFIG_FUSE_FS \
                -m CONFIG_ISO9660_FS \
                -m CONFIG_MSDOS_FS \
                -m CONFIG_NTFS3_FS \
                -m CONFIG_UDF_FS \

# 显卡
scripts/config  -d CONFIG_DRM_NOUVEAU \
                -m CONFIG_DRM_I915 \
                -m CONFIG_DRM_SIMPLEDRM \

# 蓝牙
scripts/config  \
                -d CONFIG_BT_BNEP \
                -d CONFIG_RFCOMM \
                -e CONFIG_BT_HCIBTUSB \
                -e CONFIG_BT_HCIUART \
                -e CONFIG_BT_HIDP \
                -e CONFIG_UHID \
                -m CONFIG_BT \

# 摄像头
scripts/config  \
                -d CONFIG_MEDIA_DIGITAL_TV_SUPPORT \
                -d CONFIG_MEDIA_PCI_SUPPORT \
                -d CONFIG_MEDIA_RADIO_SUPPORT \
                -d CONFIG_MEDIA_TEST_SUPPORT \
                -e CONFIG_MEDIA_CAMERA_SUPPORT \
                -e CONFIG_MEDIA_PLATFORM_SUPPORT \
                -e CONFIG_MEDIA_SUBDRV_AUTOSELECT \
                -e CONFIG_MEDIA_SUPPORT_FILTER \
                -e CONFIG_MEDIA_USB_SUPPORT \
                -e CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER \
                -e CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV \
                -e CONFIG_VIDEO_V4L2_SUBDEV_API \
                -m CONFIG_MEDIA_SUPPORT \
                -m CONFIG_SND_USB_AUDIO \
                -m CONFIG_SND_USB_UA101 \
                -m CONFIG_SND_USB_US122L \
                -m CONFIG_SND_USB_USX2Y \
                -m CONFIG_USB_VIDEO_CLASS \
                -m CONFIG_VIDEO_DEV \
                -m CONFIG_VIDEO_V4L2 \

# 无线网卡
scripts/config  \
                -e CONFIG_MT76_LEDS \
                -e CONFIG_WLAN_VENDOR_MEDIATEK \
                -m CONFIG_MT76_CORE \
                -m CONFIG_MT76_USB \
                -m CONFIG_MT76x02_LIB \
                -m CONFIG_MT76x02_USB \
                -m CONFIG_MT76x2U \
                -m CONFIG_MT76x2_COMMON \

# 手机USB网络共享
scripts/config  -m CONFIG_USB_NET_DRIVERS \
                -m CONFIG_USB_USBNET \

# USB设备支持
scripts/config  \
                -d CONFIG_USB_SERIAL \
                -e CONFIG_USB_HID \
                -e CONFIG_USB_UAS \
                -m CONFIG_QRTR \
                -m CONFIG_TYPEC \
                -m CONFIG_USB_PRINTER \
                -m CONFIG_USB_STORAGE \

# 刷新
scripts/config  --refresh

# # #
# 图形界面调整编译选项
make menuconfig

# 对比选项
echo scripts/diffconfig .config.bak .config
scripts/diffconfig .config.bak .config
echo scripts/diffconfig .config.old .config
scripts/diffconfig .config.old .config

# 输出配置文件大小
ls -lh .config

read -p "是否编译并安装内核？[y/N]" choice
case $choice in
Y | y) COMPILE_KERNEL=1 ;;
N | n | '') COMPILE_KERNEL=0 ;;
*) echo 错误选择，程序意外退出！ && exit ;;
esac

if [ "$COMPILE_KERNEL" = "1" ]; then
    make -j$(nproc) && make modules_install && make install
    find /boot/ -maxdepth 1 -mmin -1 -type f -name vmlinuz-* -exec cp -fv {} /boot/efi/EFI/gentoo/vmlinuz \; -print
    dracut --force /boot/initramfs-$(grep 'Kernel Configuration' .config | cut -d ' ' -f 3).img
    find /boot/ -maxdepth 1 -mmin -1 -type f -name initramfs-* -exec cp -fv {} /boot/efi/EFI/gentoo/initramfs.img \; -print
    ls -lh /boot/efi/EFI/gentoo/
    ls -lh /boot/vmlinuz*
    ls -lh /boot/initramfs*
    du -sh /lib/modules/*
fi
