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
rm -rfv ~/.bash_profile
rm -rfv ~/.bash_aliases
rm -rfv ~/.vscode
rm -rfv ~/.machines
rm -rfv ~/.dev
rm -rfv ~/.mozilla
rm -rfv ~/.nspawn-qq
rm -rfv ~/.config/wallpapers
rm -rfv ~/.config/fcitx5
rm -rfv ~/.config/aria2
rm -rfv ~/.config/fontconfig
rm -rfv ~/.config/user-dirs.dirs
rm -rfv ~/.config/user-dirs.locale
rm -rfv ~/.local/bin
rm -rfv ~/.local/share/fcitx5
rm -rfv ~/.local/share/fonts
rm -rfv ~/下载
rm -rfv ~/文档

[ -L ~/.local/share/flatpak ] && rm -fv ~/.local/share/flatpak
[ -L ~/.var ] && rm -fv ~/.var

[ -L ~/.bashrc ] && rm -fv ~/.bashrc && cp -fv /etc/skel/.bashrc ~/.bashrc
[ -f /etc/skel/.bashrc ] && cp -fv /etc/skel/.bashrc ~/.bashrc

[ -L ~/.local/share/templates ] && rm -fv ~/.local/share/templates
[ -L ~/.config/Code ] && rm -fv ~/.config/Code

[ -L ~/.config/user-dirs.dirs ] && rm -rfv ~/.config/user-dirs.dirs
[ -L ~/.config/user-dirs.locale ] && rm -rfv ~/.config/user-dirs.locale

mkdir -p ~/.config/Code/User
ln -sfv /home/loaden/.config/Code/User/*.json ~/.config/Code/User/
ln -sv /home/loaden/.vscode ~

ln -sv /home/loaden/.dev ~
ln -sv /home/loaden/.gitconfig ~
ln -sv /home/loaden/.ssh ~
ln -sv /home/loaden/.mozilla ~
ln -sv /home/loaden/.bash_profile ~
ln -sv /home/loaden/.bash_aliases ~
ln -sv /home/loaden/.local/bin ~/.local
ln -sv /home/loaden/.machines ~
ln -sv /home/loaden/.nspawn-qq ~
ln -sv /home/loaden/.config/wallpapers ~/.config
ln -sv /home/loaden/.config/fcitx5 ~/.config
ln -sv /home/loaden/.config/aria2 ~/.config
ln -sv /home/loaden/.local/share/fcitx5 ~/.local/share
ln -sv /home/loaden/.config/fontconfig ~/.config
ln -sv /home/loaden/.local/share/fonts ~/.local/share

if [ -z "$(grep .bash_aliases ~/.bashrc)" ]; then
    echo "[ -f ~/.bash_aliases ] && . ~/.bash_aliases" >> ~/.bashrc
fi

[ ! -d ~/云盘 ] && ln -sv /home/loaden/云盘 ~
ln -sv /home/loaden/下载 ~
ln -sv /home/loaden/文档 ~

xdg-user-dirs-update --force
fc-cache -rv
