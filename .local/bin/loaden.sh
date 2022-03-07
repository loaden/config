#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

if [ `whoami` = "loaden" ]; then
    echo "当前用户loaden不可执行该脚本，危险！"
    exit 1
fi

rm -rfv ~/.gitconfig
rm -rfv ~/.deepinwine
rm -rfv ~/.ssh
rm -rfv ~/.vscode
rm -rfv ~/.machines
rm -rfv ~/.dev
rm -rfv ~/.nspawn-deepinwine
rm -rfv ~/.config/fcitx5
rm -rfv ~/.config/fontconfig
rm -rfv ~/.config/user-dirs.dirs
rm -rfv ~/.config/user-dirs.locale
rm -rfv ~/.local/bin
rm -rfv ~/.local/share/fcitx5
rm -rfv ~/.local/share/fonts
rm -rfv ~/桌面
rm -rfv ~/下载
rm -rfv ~/模板
rm -rfv ~/公共
rm -rfv ~/文档
rm -rfv ~/音乐
rm -rfv ~/图片
rm -rfv ~/视频
rm -rfv ~/公共的
rm -rfv ~/Desktop
rm -rfv ~/Downloads
rm -rfv ~/.Templates
rm -rfv ~/.Public
rm -rfv ~/Documents
rm -rfv ~/Music
rm -rfv ~/Pictures
rm -rfv ~/Videos

[ -L ~/.local/share/flatpak ] && rm -fv ~/.local/share/flatpak
[ -L ~/.var ] && rm -fv ~/.var
[ -L ~/.bashrc ] && cp -v /etc/skel/.bashrc ~/.bashrc
[ -L ~/.bash_profile ] && cp -v /etc/skel/.bash_profile ~/.bash_profile
[ -L ~/.bash_aliases ] && rm -fv ~/.bash_aliases
[ -L ~/.local/share/templates ] && rm -fv ~/.local/share/templates
[ -L ~/.config/Code ] && rm -fv ~/.config/Code

mkdir -p ~/.config/Code/User
ln -sfv /home/loaden/.config/Code/User/*.json ~/.config/Code/User/
ln -sv /home/loaden/.vscode ~

ln -sv /home/loaden/.dev ~
ln -sv /home/loaden/.gitconfig ~
ln -sv /home/loaden/.ssh ~
ln -sv /home/loaden/.local/bin ~/.local
ln -sv /home/loaden/.machines ~
ln -sv /home/loaden/.nspawn-deepinwine ~
ln -sv /home/loaden/.config/fcitx5 ~/.config
ln -sv /home/loaden/.local/share/fcitx5 ~/.local/share
ln -sv /home/loaden/.config/user-dirs.dirs ~/.config
ln -sv /home/loaden/.config/user-dirs.locale ~/.config
ln -sv /home/loaden/.config/fontconfig ~/.config
ln -sv /home/loaden/.local/share/fonts ~/.local/share

[ ! -d ~/云盘 ] && ln -sv /home/loaden/云盘 ~
ln -sv /home/loaden/桌面 ~
ln -sv /home/loaden/下载 ~
ln -sv /home/loaden/模板 ~
ln -sv /home/loaden/公共 ~
ln -sv /home/loaden/文档 ~
ln -sv /home/loaden/音乐 ~
ln -sv /home/loaden/图片 ~
ln -sv /home/loaden/视频 ~
