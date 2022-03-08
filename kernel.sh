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
YES | yes | Y | y) make localmodconfig && sleep 1 ;;
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
scripts/config  -d CONFIG_LOCALVERSION_AUTO \
                -d MICROCODE \
                -m CONFIG_IKCONFIG \
                -e CONFIG_IKCONFIG_PROC \
                -d CONFIG_PRINTK_INDEX \
                --set-str CONFIG_DEFAULT_HOSTNAME "(none)" \
                -d CONFIG_HYPERVISOR_GUEST \
                -d CONFIG_MODULE_FORCE_LOAD \
                -e CONFIG_HIBERNATION \
                -d CONFIG_X86_X32

# Gentoo配置
scripts/config  -d CONFIG_GENTOO_LINUX_INIT_SCRIPT \
                -e CONFIG_GENTOO_LINUX_INIT_SYSTEMD

# 驱动
scripts/config  -d CONFIG_BLK_DEV_NVME \
                -d CONFIG_INPUT_JOYDEV \
                -d CONFIG_INPUT_JOYSTICK \
                -d CONFIG_INPUT_TOUCHSCREEN \
                -e CONFIG_X86_PLATFORM_DEVICES \
                -d CONFIG_CHROME_PLATFORMS \
                -d CONFIG_MELLANOX_PLATFORM \
                -d CONFIG_SURFACE_PLATFORMS \
                -d CONFIG_ANDROID

# 内核调试
scripts/config  -d CONFIG_DEBUG_KERNEL \
                -d CONFIG_FTRACE \
                -d CONFIG_DEBUG_PREEMPT \
                -d CONFIG_DEBUG_MISC \
                -d CONFIG_STRICT_DEVMEM \
                -d CONFIG_EARLY_PRINTK \
                -d CONFIG_X86_DEBUG_FPU \
                -d RUNTIME_TESTING_MENU \
                -d CONFIG_MAGIC_SYSRQ \
                -d CONFIG_DEBUG_FS \
                -d CONFIG_PRINTK_TIME \
                -d CONFIG_STACKTRACE_BUILD_ID \
                --set-val CONFIG_CONSOLE_LOGLEVEL_DEFAULT "2" \
                --set-val CONFIG_MESSAGE_LOGLEVEL_DEFAULT "3" \
                -d CONFIG_DYNAMIC_DEBUG \
                -d CONFIG_DYNAMIC_DEBUG_CORE \
                -d CONFIG_SYMBOLIC_ERRNAME \
                -d CONFIG_DEBUG_BUGVERBOSE

# 压缩模式
scripts/config  -e CONFIG_KERNEL_ZSTD \
                -e CONFIG_ZRAM \
                -e CONFIG_ZRAM_DEF_COMP_ZSTD \
                -d CONFIG_ZSWAP \
                -d CONFIG_MODULE_COMPRESS_ZSTD \
                -e CONFIG_MODULE_COMPRESS_NONE \
                -d CONFIG_RD_GZIP \
                -d CONFIG_RD_BZIP2 \
                -d CONFIG_RD_LZMA \
                -d CONFIG_RD_XZ \
                -d CONFIG_RD_LZO \
                -d CONFIG_RD_LZ4 \
                -e CONFIG_RD_ZSTD

# 桌面快速响应
scripts/config  -e CONFIG_NO_HZ_IDLE \
                -d CONFIG_NO_HZ \
                -e CONFIG_PREEMPT \
                -e CONFIG_TICK_CPU_ACCOUNTING \
                -e CONFIG_SCHED_AUTOGROUP \
                -e CONFIG_IOSCHED_BFQ \
                -e CONFIG_BFQ_GROUP_IOSCHED \
                -e CONFIG_HZ_1000

# Intel显卡需要
scripts/config  -e CONFIG_CHECKPOINT_RESTORE

# USB设备支持
scripts/config  -e CONFIG_USB_HID \
                -m CONFIG_USB_PRINTER \
                -m CONFIG_USB_STORAGE \
                -m CONFIG_TYPEC \
                -d CONFIG_USB_SERIAL \
                -d CONFIG_USB_OHCI_HCD \
                -m CONFIG_QRTR \
                -e CONFIG_USB_UAS

# BPF调整
scripts/config  -e CONFIG_BPF \
                -e CONFIG_HAVE_EBPF_JIT \
                -e CONFIG_CGROUP_BPF \
                -e CONFIG_BPF_UNPRIV_DEFAULT_OFF \
                -e CONFIG_BPF_JIT \
                -e CONFIG_BPF_JIT_ALWAYS_ON \
                -e CONFIG_BPF_JIT_DEFAULT_ON \
                -d CONFIG_BPF_PRELOAD

# systemd需要
scripts/config  -e CONFIG_EXPERT \
                -e CONFIG_FHANDLE \
                -e CONFIG_EPOLL \
                -e CONFIG_SIGNALFD \
                -e CONFIG_TIMERFD \
                -e CONFIG_EVENTFD \
                -e CONFIG_SHMEM \
                -e CONFIG_DEVTMPFS \
                -d CONFIG_SYSFS_DEPRECATED \
                -e CONFIG_BPF_SYSCALL \
                -e CONFIG_INOTIFY_USER \
                -e CONFIG_PROC_FS \
                -e CONFIG_SYSFS

# 虚拟机需要
scripts/config  -e CONFIG_VIRTUALIZATION \
                -m CONFIG_KVM \
                -m CONFIG_VIRTIO_MEM \
                -m CONFIG_VIRTIO_FS

# 牺牲安全性换性能
scripts/config  -d CONFIG_RETPOLINE \
                -e CONFIG_CMDLINE_BOOL \
                --set-str CONFIG_CMDLINE "spectre_v1=off spectre_v2=off spec_store_bypass_disable=off pti=off" \
                -d CONFIG_X86_INTEL_TSX_MODE_AUTO \
                -e CONFIG_X86_INTEL_TSX_MODE_ON \
                -d CONFIG_STACKPROTECTOR \
                -d CONFIG_MQ_IOSCHED_KYBER \
                -d CONFIG_SECURITY \
                -d CONFIG_HARDENED_USERCOPY \
                -d CONFIG_SECURITYFS \
                -d CONFIG_SECURITY_DMESG_RESTRICT \
                -d CONFIG_KEY_NOTIFICATIONS \
                -d CONFIG_KEY_DH_OPERATIONS \
                -d CONFIG_KEYS_REQUEST_CACHE \
                -d CONFIG_PERSISTENT_KEYRINGS \
                -d CONFIG_PAGE_TABLE_ISOLATION

# 苹果手机
scripts/config  -m USB_NET_DRIVERS \
                -m CONFIG_USB_IPHETH \
                -m CONFIG_APPLE_MFI_FASTCHARGE

# 文件系统
scripts/config  -e CONFIG_BTRFS_FS \
                -e CONFIG_BTRFS_FS_POSIX_ACL \
                -m CONFIG_EXT4_FS \
                -e CONFIG_EXT4_FS_POSIX_ACL \
                -e CONFIG_AUTOFS_FS \
                -m CONFIG_FUSE_FS \
                -e CONFIG_VFAT_FS \
                -e CONFIG_FAT_DEFAULT_UTF8 \
                -m CONFIG_EXFAT_FS \
                -m CONFIG_NTFS3_FS \
                -e CONFIG_NTFS3_LZX_XPRESS \
                -e CONFIG_NTFS3_FS_POSIX_ACL \
                -e CONFIG_NETWORK_FILESYSTEMS \
                -d CONFIG_FS_ENCRYPTION \
                -d CONFIG_FS_VERITY \
                -m CONFIG_MSDOS_FS \
                -m CONFIG_ISO9660_FS \
                -m CONFIG_UDF_FS \
                -m CONFIG_CIFS

# 显卡
scripts/config  -d CONFIG_DRM_NOUVEAU \
                -m CONFIG_DRM_I915 \
                -m CONFIG_DRM_SIMPLEDRM

# 蓝牙
scripts/config  -m CONFIG_BT \
                -m CONFIG_BT_INTEL \
                -m CONFIG_BT_BCM \
                -m CONFIG_BT_RTL \
                -m CONFIG_BT_HCIBTUSB \
                -e CONFIG_BT_HCIBTUSB_AUTOSUSPEND \
                -e CONFIG_BT_HCIBTUSB_BCM \
                -e CONFIG_BT_HCIBTUSB_MTK \
                -e CONFIG_BT_HCIBTUSB_RTL \
                -d CONFIG_BT_DEBUGFS

# 网卡
scripts/config  -m CONFIG_MT76_CORE \
                -e CONFIG_MT76_LEDS \
                -m CONFIG_MT76_USB \
                -m CONFIG_MT76x02_LIB \
                -m CONFIG_MT76x02_USB \
                -m CONFIG_MT76x2_COMMON \
                -m CONFIG_MT76x2U

# 摄像头
scripts/config  -m CONFIG_MEDIA_SUPPORT \
                -e CONFIG_MEDIA_SUPPORT_FILTER \
                -e CONFIG_MEDIA_SUBDRV_AUTOSELECT \
                -e CONFIG_MEDIA_CAMERA_SUPPORT \
                -e CONFIG_MEDIA_PLATFORM_SUPPORT \
                -m CONFIG_VIDEO_DEV \
                -e CONFIG_MEDIA_USB_SUPPORT \
                -m CONFIG_USB_VIDEO_CLASS \
                -e CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV \
                -m CONFIG_SND_USB_AUDIO \
                -e CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER \
                -m CONFIG_SND_USB_UA101 \
                -m CONFIG_SND_USB_USX2Y \
                -m CONFIG_SND_USB_US122L \
                -e CONFIG_VIDEO_V4L2_SUBDEV_API \
                -d CONFIG_VIDEO_V4L2_SUBDEV_API \
                -d CONFIG_MEDIA_DIGITAL_TV_SUPPORT \
                -d CONFIG_MEDIA_RADIO_SUPPORT \
                -d CONFIG_MEDIA_TEST_SUPPORT \
                -d CONFIG_MEDIA_PCI_SUPPORT

# 精简
scripts/config  -d CONFIG_PARAVIRT \
                -d CONFIG_ARCH_CPUIDLE_HALTPOLL \
                -d CONFIG_PVH \
                -d CONFIG_JAILHOUSE_GUEST \
                -d CONFIG_ACRN_GUEST \
                -d CONFIG_NET_FC \
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
                -d CONFIG_NET_VENDOR_MICROSOFT \
                -d CONFIG_NET_VENDOR_LITEX \
                -d CONFIG_NET_VENDOR_MARVELL \
                -d CONFIG_NET_VENDOR_MELLANOX \
                -d CONFIG_NET_VENDOR_MICREL \
                -d CONFIG_NET_VENDOR_MICROCHIP \
                -d CONFIG_NET_VENDOR_MICROSEMI \
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
                -d CONFIG_NET_VENDOR_SOLARFLARE \
                -d CONFIG_NET_VENDOR_SILAN \
                -d CONFIG_NET_VENDOR_SIS \
                -d CONFIG_NET_VENDOR_SMSC \
                -d CONFIG_NET_VENDOR_SOCIONEXT \
                -d CONFIG_NET_VENDOR_STMICRO \
                -d CONFIG_NET_VENDOR_SUN \
                -d CONFIG_NET_VENDOR_SYNOPSYS \
                -d CONFIG_NET_VENDOR_TEHUTI \
                -d CONFIG_NET_VENDOR_TI \
                -d CONFIG_NET_VENDOR_VIA \
                -d CONFIG_NET_VENDOR_WIZNET \
                -d CONFIG_NET_VENDOR_XILINX \
                -d CONFIG_WLAN_VENDOR_MICROCHIP \
                -d CONFIG_WLAN_VENDOR_RALINK \
                -d CONFIG_WLAN_VENDOR_REALTEK \
                -d CONFIG_WLAN_VENDOR_RSI \
                -d CONFIG_WLAN_VENDOR_ST \
                -d CONFIG_WLAN_VENDOR_TI \
                -d CONFIG_WLAN_VENDOR_ZYDAS \
                -d CONFIG_WLAN_VENDOR_QUANTENNA \
                -d CONFIG_ISDN \
                -d CONFIG_VIRT_DRIVERS \
                -d CONFIG_STAGING \
                -d CONFIG_DEBUG_INFO \
                -d CONFIG_BOOT_PRINTK_DELAY \
                -d CONFIG_SCHED_STACK_END_CHECK \
                -d CONFIG_DEBUG_SHIRQ \
                -d CONFIG_SOFTLOCKUP_DETECTOR \
                -d CONFIG_HARDLOCKUP_DETECTOR \
                -d CONFIG_DETECT_HUNG_TASK \
                -d CONFIG_DEBUG_SHIRQ \
                -d CONFIG_SOFTLOCKUP_DETECTOR \
                -d CONFIG_HARDLOCKUP_DETECTOR \
                -d CONFIG_DETECT_HUNG_TASK \
                -d CONFIG_SCHEDSTATS \
                -d CONFIG_DEBUG_LIST \
                -d CONFIG_LATENCYTOP \
                -d CONFIG_X86_DECODER_SELFTEST \
                -d CONFIG_DEBUG_BOOT_PARAMS \
                -d CONFIG_KALLSYMS_ALL

# sys-kernel/gentoo-kernel-bin内核localmodconfig
scripts/config  -d CONFIG_NETFILTER_XTABLES \
                -d CONFIG_IP_NF_IPTABLES \
                -d CONFIG_MTD \
                -d CONFIG_MAC_EMUMOUSEBTN \
                -d CONFIG_INPUT_MOUSEDEV \
                -d CONFIG_INPUT_MOUSEDEV \
                -d CONFIG_IPMI_HANDLER \
                -d CONFIG_VIDEO_IR_I2C \
                -d CONFIG_MEDIA_TUNER_TEA5761 \
                -d CONFIG_MEDIA_TUNER_TEA5767 \
                -d CONFIG_SND_HRTIMER \
                -d CONFIG_CRYPTO_USER \
                -d CONFIG_CRYPTO_LZO \
                -d CONFIG_CRYPTO_842 \
                -d CONFIG_CRYPTO_LZ4HC

# 再次与Arch内核配置对比
scripts/config  -d CONFIG_KEXEC_JUMP \
                -d CONFIG_PM_GENERIC_DOMAINS \
                -d CONFIG_KVM_INTEL \
                -d CONFIG_KVM_XEN \
                -d CONFIG_HMM_MIRROR \
                -d CONFIG_WLAN_VENDOR_ADMTEK \
                -d CONFIG_WLAN_VENDOR_ATH \
                -d CONFIG_WLAN_VENDOR_ATMEL \
                -d CONFIG_WLAN_VENDOR_BROADCOM \
                -d CONFIG_WLAN_VENDOR_CISCO \
                -d CONFIG_WLAN_VENDOR_INTEL \
                -d CONFIG_WLAN_VENDOR_INTERSIL \
                -d CONFIG_WLAN_VENDOR_MARVELL \
                -d CONFIG_MFD_INTEL_PMC_BXT \
                -m CONFIG_CEC_CORE \
                -d CONFIG_MEDIA_ANALOG_TV_SUPPORT \
                -d CONFIG_MEDIA_TUNER \
                -d CONFIG_DRM_DEBUG_MM \
                -d CONFIG_DRM_RADEON \
                -d CONFIG_DRM_AMDGPU \
                -d CONFIG_DRM_VIRTIO_GPU \
                -d CONFIG_SND_SEQUENCER \
                -d CONFIG_VIRTIO_MENU \
                -d CONFIG_VHOST_MENU \
                -d CONFIG_ACPI_WMI \
                -d CONFIG_X86_PLATFORM_DRIVERS_DELL \
                -d CONFIG_RCU_TRACE \
                -e CONFIG_V4L_PLATFORM_DRIVERS \
                -e CONFIG_V4L_MEM2MEM_DRIVERS \
                -d CONFIG_VGA_SWITCHEROO \
                -e CONFIG_INIT_STACK_NONE \
                -d CONFIG_INIT_STACK_ALL_ZERO \
                -m CONFIG_I2C_ALGOBIT \
                -e CONFIG_MEDIA_ATTACH \
                -e CONFIG_USB_XHCI_PCI

# iwd
scripts/config  -e CONFIG_CRYPTO_USER_API_SKCIPHER \
                -e CONFIG_CRYPTO_USER_API_HASH \
                -e CONFIG_CRYPTO_HMAC \
                -e CONFIG_CRYPTO_CMAC \
                -e CONFIG_CRYPTO_MD4 \
                -e CONFIG_CRYPTO_MD5 \
                -e CONFIG_CRYPTO_SHA256 \
                -e CONFIG_CRYPTO_SHA512 \
                -e CONFIG_CRYPTO_AES \
                -e CONFIG_CRYPTO_ECB \
                -e CONFIG_CRYPTO_DES \
                -e CONFIG_CRYPTO_CBC \
                -e CONFIG_KEY_DH_OPERATIONS

# 同步单位电脑配置
scripts/config  -d CONFIG_AMD_MEM_ENCRYPT

# 刷新
scripts/config  --refresh

# # #
# 图形界面调整编译选项
make menuconfig

# 对比选项
scripts/diffconfig .config.bak .config

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
    find /boot/ -maxdepth 1 -mmin -1 -type f -name vmlinuz-* -exec cp {} /boot/efi/EFI/gentoo/vmlinuz \; -print
    ls -lh /boot/efi/EFI/gentoo/
    ls -lh /boot/vmlinuz*
    du -sh /lib/modules/*
fi
