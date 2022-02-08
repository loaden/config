#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

if [ `whoami` == "loaden" ]; then
    echo "当前用户loaden不可执行该脚本，危险！"
    exit 1
fi

rm -rf ~/.gitconfig
rm -rf ~/.stalonetray.rc
rm -rf ~/.deepinwine
rm -rf ~/.ssh
rm -rf ~/.var
rm -rf ~/.vscode
rm -rf ~/.machines
rm -rf ~/.steam*
rm -rf ~/.dev
rm -rf ~/.tim
rm -rf ~/.lightqq
rm -rf ~/.wechat
rm -rf ~/.minecraft
rm -rf ~/.vnc
rm -rf ~/.themes
rm -rf ~/.kde*
rm -rf ~/.kingsoft
rm -rf ~/.bash_profile
rm -rf ~/.bash_aliases
rm -rf ~/.xsessionrc
rm -rf ~/.nspawn-deepinwine
rm -rf ~/.config/fcitx
rm -rf ~/.config/fcitx5
rm -rf ~/.config/ibus
rm -rf ~/.config/microsoft-edge*
rm -rf ~/.config/google-chrome*
rm -rf ~/.config/uTools
rm -rf ~/.config/user-dirs.dirs
rm -rf ~/.config/user-dirs.locale
rm -rf ~/.local/bin
rm -rf ~/.local/share/fcitx5
rm -rf ~/.local/share/flatpak
rm -rf ~/.local/share/fonts
rm -rf ~/.local/share/templates
rm -rf ~/桌面
rm -rf ~/下载
rm -rf ~/模板
rm -rf ~/公共
rm -rf ~/文档
rm -rf ~/音乐
rm -rf ~/图片
rm -rf ~/视频
rm -rf ~/公共的
rm -rf ~/Desktop
rm -rf ~/Downloads
rm -rf ~/.Templates
rm -rf ~/.Public
rm -rf ~/Documents
rm -rf ~/Music
rm -rf ~/Pictures
rm -rf ~/Videos

unlink ~/.config/Code
mkdir -p ~/.config/Code/User
ln -sf /home/loaden/.config/Code/User/*.json ~/.config/Code/User/

ln -s /home/loaden/.gitconfig ~
ln -s /home/loaden/.ssh ~
ln -s /home/loaden/.var ~
ln -s /home/loaden/.vscode ~
ln -s /home/loaden/.machines ~
ln -s /home/loaden/.nspawn-deepinwine ~
ln -s /home/loaden/.dev ~
ln -s /home/loaden/.bash_profile ~
ln -s /home/loaden/.bash_aliases ~
ln -s /home/loaden/.config/fcitx5 ~/.config
ln -s /home/loaden/.config/ibus ~/.config
ln -s /home/loaden/.config/microsoft-edge* ~/.config/
ln -s /home/loaden/.config/user-dirs.dirs ~/.config
ln -s /home/loaden/.config/user-dirs.locale ~/.config
ln -s /home/loaden/.local/bin ~/.local
ln -s /home/loaden/.local/share/fcitx5 ~/.local/share
ln -s /home/loaden/.local/share/flatpak ~/.local/share
ln -s /home/loaden/.local/share/fonts ~/.local/share
ln -s /home/loaden/.local/share/templates ~/.local/share
[ ! -d ~/云盘 ] && ln -s /home/loaden/云盘 ~
ln -s /home/loaden/桌面 ~
ln -s /home/loaden/下载 ~
ln -s /home/loaden/模板 ~
ln -s /home/loaden/公共 ~
ln -s /home/loaden/文档 ~
ln -s /home/loaden/音乐 ~
ln -s /home/loaden/图片 ~
ln -s /home/loaden/视频 ~

