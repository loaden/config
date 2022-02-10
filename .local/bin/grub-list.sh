#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

[ -f /boot/grub/grub.cfg ] && awk -F\' '$1=="menuentry " || $1=="submenu " {print i++ " : " $2}; /\tmenuentry / {print "\t" i-1">"j++ " : " $2};' /boot/grub/grub.cfg && exit 0

sudo awk -F\' '$1=="menuentry " || $1=="submenu " {print i++ " : " $2}; /\tmenuentry / {print "\t" i-1">"j++ " : " $2};' /boot/grub2/grub.cfg
