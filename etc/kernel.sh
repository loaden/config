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
export LLVM=1

# 版本信息
scripts/config  -d CONFIG_LOCALVERSION_AUTO

# 压缩模式
scripts/config  -e CONFIG_KERNEL_ZSTD \
                -e CONFIG_ZRAM \
                -e CONFIG_ZRAM_DEF_COMP_ZSTD \
                -d CONFIG_ZSWAP \
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
                -e CONFIG_PREEMPT \
                -e CONFIG_TICK_CPU_ACCOUNTING \
                -e CONFIG_SCHED_AUTOGROUP \
                -e CONFIG_IOSCHED_BFQ \
                -e CONFIG_HZ_1000

# Intel显卡需要
scripts/config  -e CONFIG_CHECKPOINT_RESTORE

# 启用Clang薄LTO优化
scripts/config  -e CONFIG_LTO_CLANG_THIN

# USB设备支持
scripts/config  -e CONFIG_USB_HID \
                -m CONFIG_USB_PRINTER \
                -m CONFIG_USB_STORAGE \
                -m CONFIG_TYPEC \
                -d CONFIG_USB_SERIAL \
                -d CONFIG_USB_OHCI_HCD
# BPF调整
scripts/config  -e CONFIG_BPF \
                -e CONFIG_HAVE_EBPF_JIT \
                -e CONFIG_CGROUP_BPF \
                -e CONFIG_BPF_UNPRIV_DEFAULT_OFF \
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
                -m CONFIG_VIRT_DRIVERS \
                -m CONFIG_VIRTIO_MEM \
                -m CONFIG_VIRTIO_FS

# 牺牲安全性换性能
scripts/config  -d CONFIG_RETPOLINE \
                -e CONFIG_CMDLINE_BOOL \
                --set-str CONFIG_CMDLINE "spectre_v1=off spectre_v2=off spec_store_bypass_disable=off pti=off" \
                -e CONFIG_X86_INTEL_TSX_MODE_ON \
                -d CONFIG_STACKPROTECTOR \
                -d CONFIG_MQ_IOSCHED_KYBER \
                -d CONFIG_SECURITY

# 蓝牙
scripts/config  -u CONFIG_BT
scripts/config  -m CONFIG_BT

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
                -e CONFIG_NETWORK_FILESYSTEMS

# 显卡
scripts/config  -u CONFIG_DRM
scripts/config  -m CONFIG_DRM
scripts/config  -d CONFIG_DRM_NOUVEAU \
                -m CONFIG_DRM_I915 \
                -m CONFIG_DRM_SIMPLEDRM


# 网卡
scripts/config  -u CONFIG_ETHERNET \
                -u CONFIG_WLAN
scripts/config  -e CONFIG_ETHERNET \
                -e CONFIG_WLAN
scripts/config  -e CONFIG_NET_VENDOR_REALTEK \
                -e CONFIG_WLAN_VENDOR_MEDIATEK \
                -m CONFIG_MT76x2U

# 禁止内核调试
scripts/config  -d CONFIG_DEBUG_KERNEL

# 本机再次localyesconfig后补充配置
scripts/config  -m CONFIG_QRTR  # Qualcomm IPC Router support
scripts/config  -m CONFIG_BT_INTEL \
                -m CONFIG_BT_BCM \
                -m CONFIG_BT_RTL \
                -m CONFIG_BT_HCIBTUSB \
                -e CONFIG_BT_HCIBTUSB_AUTOSUSPEND \
                -e CONFIG_BT_HCIBTUSB_BCM \
                -e CONFIG_BT_HCIBTUSB_MTK \
                -e CONFIG_BT_HCIBTUSB_RTL # 蓝牙

scripts/config  -m CONFIG_MT76_CORE \
                -m CONFIG_MT76_LEDS \
                -m CONFIG_MT76_USB \
                -m CONFIG_MT76x02_LIB \
                -m CONFIG_MT76x02_USB \
                -m CONFIG_MT76x2_COMMON \
                -m CONFIG_MT76x2U # 无线网卡

scripts/config  -m CONFIG_MEDIA_SUPPORT \
                -e CONFIG_MEDIA_SUPPORT_FILTER \
                -e CONFIG_MEDIA_SUBDRV_AUTOSELECT \
                -e CONFIG_MEDIA_CAMERA_SUPPORT \
                -e CONFIG_MEDIA_ANALOG_TV_SUPPORT \
                -e CONFIG_MEDIA_DIGITAL_TV_SUPPORT \
                -e CONFIG_MEDIA_RADIO_SUPPORT \
                -e CONFIG_MEDIA_PLATFORM_SUPPORT \
                -m CONFIG_VIDEO_DEV \
                -e CONFIG_MEDIA_CONTROLLER \
                -m CONFIG_DVB_CORE \
                -e CONFIG_MEDIA_USB_SUPPORT \
                -m CONFIG_USB_VIDEO_CLASS \
                -e CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV \
                -m CONFIG_SND_USB_AUDIO \
                -e CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER \
                -m CONFIG_SND_USB_UA101 \
                -m CONFIG_SND_USB_USX2Y \
                -m CONFIG_SND_USB_US122L # 摄像头

#
# Video4Linux options
#
#CONFIG_VIDEO_V4L2=m
#CONFIG_VIDEO_V4L2_I2C=y
#CONFIG_VIDEO_V4L2_SUBDEV_API=y
#
# CONFIG_INPUT_UINPUT=m User level driver support
#

# 图形界面调整编译选项
make menuconfig

# 对比选项
scripts/diffconfig .config.bak .config | less

read -p "是否编译并安装内核？[y/N]" choice
case $choice in
Y | y) COMPILE_KERNEL=1 ;;
N | n | '') COMPILE_KERNEL=0 ;;
*) echo 错误选择，程序意外退出！ && exit ;;
esac

if [ "$COMPILE_KERNEL" = "1" ]; then
    make -j$(nproc) && make modules_install && make install && dracut -f && grub-mkconfig -o /boot/grub/grub.cfg
    ls -lh /boot/vmlinuz* /boot/initramfs*
    du -sh /lib/modules/
fi
