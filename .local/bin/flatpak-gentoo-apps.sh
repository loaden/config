#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

if [[ -n $(flatpak remote-list | grep fcitx5-unstable) ]]; then
    flatpak install fcitx5-unstable org.fcitx.Fcitx5 org.fcitx.Fcitx5.Addon.Rime org.fcitx.Fcitx5.Addon.Lua
fi

if [[ -n $(flatpak --system remote-list | grep flathub) ]]; then
    TARGET="--system"
fi

if [[ -n $(flatpak --user remote-list | grep flathub) ]]; then
    TARGET="--user"
fi

function install_app()
{
    [ -z $1 ] && echo empty arg '$1' && return

    if [[ -z $(flatpak list --app |grep $1) ]]; then
        flatpak install $TARGET -y $1
    fi
}

install_app com.obsproject.Studio
install_app net.agalwood.Motrix
install_app org.kde.kdenlive
install_app ch.openboard.OpenBoard
install_app org.filezillaproject.Filezilla
install_app org.kde.gwenview
install_app org.ardour.Ardour
install_app net.codeindustry.MasterPDFEditor
install_app io.github.Icalingua.Icalingua
install_app com.github.hluk.copyq
