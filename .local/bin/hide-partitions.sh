#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

# 确认管理员权限
if [[ $EUID != 0 ]]; then
    echo "请打开终端，在脚本前添加 sudo 后执行。"
    exit 1
fi

mkdir -pv /etc/udev/rules.d
cat > /etc/udev/rules.d/90-hide_parts.rules <<EOF
ENV{ID_FS_LABEL}=="Windows", ENV{UDISKS_IGNORE}="1"
EOF

