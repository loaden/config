#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo apt install acpid thermald -y
sudo apt install gnome-tweaks -y
sudo systemctl enable acpid.service
sudo systemctl enable thermald.service

sudo apt purge anthy* -y
sudo apt purge goldendict -y
sudo apt purge evolution -y
sudo apt purge gnome-games -y
sudo apt purge gnome-music -y
sudo apt purge hdate-applet -y
sudo apt purge ibus-mozc ibus-m17n ibus-hangul -y
sudo apt purge libreoffice-common -y
sudo apt purge libreoffice* -y
sudo apt purge mlterm* -y
sudo apt purge mozc-* -y
sudo apt purge qemu* -y
sudo apt purge rhythmbox -y
sudo apt purge synaptic -y
sudo apt purge transmission* -y
sudo apt purge xiterm+thai -y
sudo apt purge xterm -y

source `dirname ${BASH_SOURCE[0]}`/debian-apps.sh
sudo apt autopurge -y
