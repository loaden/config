#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

if [ `whoami` = "loaden" ]; then
    echo "当前用户loaden不可执行该脚本，危险！"
    exit 1
fi

rm -rf ~/.gitconfig
rm -rf ~/.deepinwine
rm -rf ~/.ssh
rm -rf ~/.vscode
rm -rf ~/.machines
rm -rf ~/.dev
rm -rf ~/.nspawn-deepinwine
rm -rf ~/.config/fcitx5
rm -rf ~/.config/fontconfig
rm -rf ~/.config/user-dirs.dirs
rm -rf ~/.config/user-dirs.locale
rm -rf ~/.local/bin
rm -rf ~/.local/share/fcitx5
rm -rf ~/.local/share/fonts
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

[ -L ~/.local/share/flatpak ] && rm -fv ~/.local/share/flatpak
[ -L ~/.var ] && rm -fv 
[ -L ~/.bashrc ] && cp /etc/skel/.bashrc ~/.bashrc
[ -L ~/.bash_profile ] &&  cp /etc/skel/.bash_profile ~/.bash_profile
[ -L ~/.bash_aliases ] && rm -fv ~/.bash_aliases
[ -L ~/.local/share/templates ] && rm -fv ~/.local/share/templates
[ -L ~/.config/Code ] && rm -fv ~/.config/Code

mkdir -p ~/.config/Code/User
ln -sf /home/loaden/.config/Code/User/*.json ~/.config/Code/User/
ln -s /home/loaden/.vscode ~

ln -s /home/loaden/.dev ~
ln -s /home/loaden/.gitconfig ~
ln -s /home/loaden/.ssh ~
ln -s /home/loaden/.local/bin ~/.local
ln -s /home/loaden/.machines ~
ln -s /home/loaden/.nspawn-deepinwine ~
ln -s /home/loaden/.config/fcitx5 ~/.config
ln -s /home/loaden/.local/share/fcitx5 ~/.local/share
ln -s /home/loaden/.config/user-dirs.dirs ~/.config
ln -s /home/loaden/.config/user-dirs.locale ~/.config
ln -s /home/loaden/.config/fontconfig ~/.config
ln -s /home/loaden/.local/share/fonts ~/.local/share

[ ! -d ~/云盘 ] && ln -s /home/loaden/云盘 ~
ln -s /home/loaden/桌面 ~
ln -s /home/loaden/下载 ~
ln -s /home/loaden/模板 ~
ln -s /home/loaden/公共 ~
ln -s /home/loaden/文档 ~
ln -s /home/loaden/音乐 ~
ln -s /home/loaden/图片 ~
ln -s /home/loaden/视频 ~
