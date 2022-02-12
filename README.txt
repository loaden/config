Gentoo正确安装（amd64+systemd)
● 参考官方维基为主：https://wiki.gentoo.org/wiki/Handbook:AMD64/zh-cn
● 与官方维基对应的安装要点与补充：
    ○ 安装镜像下载地址：https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/amd64/autobuilds/current-install-amd64-minimal/
    ■ 选择install-amd64-minimal-*-.iso，放到Ventoy制作好的启动盘里。
    ■ 可以提前下载stage3：stage3-amd64-systemd-*.tar.xz，也可以进入安装shell后用links下载，推荐后者：links mirrors.tuna.tsinghua.edu.cn/gentoo
    ○ UEFI模式进入安装shell后联网：net-setup，会有图形界面，按提示操作。
    ○ 磁盘分区，推荐btrfs子卷安装，例如：@gentoo
    ○ 挂载根分区：mount -o subvol=@gentoo /dev/sda2 /mnt/gentoo ，千万别直接挂到/mnt，因为minimal安装镜像的各种工具实际在/mnt/livecd下，不能覆盖。
    ○ 解压stage3文件到/mnt/gentoo，解压参数必须满足官方维基要求。
    ○ 建议写个脚本挂载分区，因为优化内核编译时，可能要多次进入livecd。一定要手动编译内核，不要用genkernel自动编译，那样就索然无味了。
    ○ 根文件系统和EFI分区的vfat文件系统不能编译成模块（当启用内核模块压缩时），必须内核内置，否则无法挂载。exFAT和NTFS可以编译成模块按需加载。
    ○ USB输入设备（比如键盘和鼠标）或其他USB设备，必须启用(CONFIG_HID_GENERIC and CONFIG_USB_HID, CONFIG_USB_SUPPORT, CONFIG_USB_XHCI_HCD, CONFIG_USB_EHCI_HCD, CONFIG_USB_OHCI_HCD)，否则不可用。
    ○ 官方维基指南中很多配置都是写给自家的OpenRC的，systemd用户可以无视。很多配置可以以后再说，不用急着配。
    ○ systemd用户需要执行一次：systemd-machine-id-setup 创建机器 ID，这个 ID 会被systemd 日志和 systemd-networkd 用到。再执行一次：systemctl preset-all --preset-mode=enable-only 激活一些默认应处于启用状态的 systemd 单元，其中许多单元都是基础系统功能所必需的。
    ○ make -j3 && make modules_install && make install
    ○ genkernel --kernel-config=.config --compress-initramfs-type=zstd --install initramfs
    ○ 引导直接：emerge grub，然后grub-install、grub-mkconfig就行了。


Linux内核编译钻研
钻研一：快速配置硬件驱动
● 尝试一：“make localmodconfig”和“make localyesconfig”，大概意思就是系统自动检测现有内核加载了哪些模块，然后在内核源码的config设置里将已加载的模块自动标记为“M”或“*”，没加载的模块自动去除选择。思路：
1. 先安装一个硬件驱动支持好的通用发行版如 Ubuntu、Garuda 等；
2. 从http://kernel.org下载一份内核源码；
3. 将所有以后用到的硬件设备全部插到电脑上激活使用一遍(包括蓝牙、wifi、鼠标、u盘、拓展坞、摄像头等)，让通用发行版的内核加载这些设备的驱动；
4. 解压下载来的内核源码，执行“make localmodconfig”命令，完成后再执行“make
menuconfig”命令，然后“save”你的内核配置，于是你就得到了一份专属于自己电脑的.config内核配置文件了。
5. 参考文档：make help
● 尝试二：尝试 make menuconfig all 编译，使用一遍所有硬件，通过 lsmod | awk '{if($3>0) print $_ }' 找出 used 大于0的驱动模块，并认为是当前电脑必备的模块。
● 查看内核编译配置区别：scripts/diffconfig .config .config.bak
● 参考链接：https://zhuanlan.zhihu.com/p/165322740
钻研二：通用设置与性能优化
● 提高桌面响应速度：将“Preemption Model”设为“Preemptible Kernel (Low-Latency Desktop)”、将“Timer tick handling”设为“Idle dynticks system (tickless idle)”、将“Cputime
accounting”设为“Simple tick based cputime accounting”。
● “Automatic process group scheduling”，这号称linux桌面系统的“鸡血补丁”，开启后能显著降低操作延迟、提升程序响应速度。
● 内存大于8G的用户：不设置swap分区（无法休眠），启用zram。zram不需要任何实际的物理swap分区，它的实现原理是直接在内存中开辟出一块固定大小的区域来，作为一个虚拟的swap分区，在内存容量不足的情况下，将多余的内存数据经过压缩然后放到这块区域中，从而变相地增加内存的容量。由于这个虚拟的swap分区存在于内存中，而内存的读写速度是远远高于SSD的，所以zram区域中数据解压缩的速度也是很快的，几乎感觉不到延迟，但是代价是需要更多的CPU资源来提供数据的解压缩计算。这项技术在windows和android平台上名叫“内存压缩技术”，建议内存小于32G的用户开启： Device Drivers - Block devices - Compressed RAM block device support，并选择 zstd 压缩算法。禁用zswap：Memory Management options - Compressed cache for swap pages。
● 使用intel核显开源驱动mesa的，必须开启“Checkpoint/restore support”。
● “Enable loadable module support - Module compression mode”设置为None，否则默认不加载内核模块。
● “Processor type and features - Avoid speculative indirect branches in kernel”表示给内核打上retpoline补丁。2018年Intel、AMD和ARM处理器均爆出了Meltdown（熔断）和Spectre（幽灵）内存崩溃漏洞，几乎涉及了以往开发的每一款处理器，其影响几乎遍及全世界的每一台电脑。retpoline补丁就是为了补上这两个严重的漏洞的，但是会带来一个不好的问题，那就是CPU性能的下降。所以为了提高性能，我选择禁用此选项，以牺牲内核安全性的代价换取性能。修改内核启动参数禁用spectre_v1、spectre_v2、spectre_v4补丁：Processor type and features - Built-in kernel command line，添加：spectre_v1=off spectre_v2=off spec_store_bypass_disable=off pti=off，也可以添加GRUB内核启动参数：
# nano /etc/default/grub
GRUB_CMDLINE_LINUX="spectre_v1=off spectre_v2=off spec_store_bypass_disable=off pti=off"
# grub-mkconfig -o /boot/grub/grub.cfg
● 开启“Processor type and features - TSX enable mode”，这也是一项牺牲内核安全性换取性能的实现。英特尔事务扩展技术（TSX）是intel为旗下的CPU开发的一项优化指令集，但是存在僵尸负载漏洞（ZombieLoad）。
● 启用“BFQ I/O scheduler”，即当下在各大桌面发行版如Ubuntu、Manjaro、SUSE中广为流行的BFQ调度器，可以打造快速实时响应的桌面系统。 其余两个调度器可放心禁用。 另外以前的CFQ调度器现在已被BFQ调度器取代。
● 禁用“General architecture-dependent options - Stack Protector buffer overflow detection”，相当于gcc编译器的“-fno-stack-protector”选项，禁用程序栈堆溢出保护。由于栈堆溢出保护需要一定的性能开销，所以为了提高性能，可以禁用此选项，以牺牲内核安全性的代价换取性能。
● 禁用“Security options - Enable different security models”：牺牲内核安全性换取性能。
● 启用“File systems - DOS/FAT/EXFAT/NT Filesystems”中的 exFAT 和 NTFS Read-Write file system support 支持，勾选NTFS下的所有特性。
● Nvidia独立显卡的闭源驱动：内核中一切与nvidia和nouveau有关的驱动全部禁用！这是遵照Nvidia官方闭源驱动说明书册的指导原则，否则linux内核中的nvidia驱动会和Nvidia官方闭源驱动模块起冲突。Device Drivers - Graphics support - 酌情关闭。
● 禁用内核调试：Kernel hacking - Kernel debugging.
● 禁用“Processor type and features - Linux guest support”：禁止在虚拟机中运行　。
● systemd必须启用的内核选项（仅供参考）：https://wiki.gentoo.org/wiki/Systemd/zh-cn#.E5.86.85.E6.A0.B8
● 参考链接：https://zhuanlan.zhihu.com/p/164910411
