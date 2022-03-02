#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

#如果下载速度慢，请修改成国内镜像源
#参考1：https://zh.fedoracommunity.org/2020/05/13/try-on-flatpak-mainland-china-mirror.html
#参考2:https://mirrors.sjtug.sjtu.edu.cn/docs/flathub
#参考2英文：https://barthalion.blog/test-driving-flathub-mirror-for-users-in-china/
#参考3:https://github.com/flathub/flathub/issues/813
#换源：flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub

if [[ -n $(flatpak --system remote-list | grep appcenter) ]]; then
    flatpak install --system -y appcenter com.github.calo001.fondo
    flatpak install --system -y appcenter com.github.ckruse.ColorMate
    flatpak install --system -y appcenter com.github.donadigo.eddy
    flatpak install --system -y appcenter com.github.subhadeepjasu.pebbles
fi

if [[ -n $(flatpak remote-list | grep fcitx5-unstable) ]]; then
    flatpak install -y fcitx5-unstable org.fcitx.Fcitx5
    flatpak install -y fcitx5-unstable org.fcitx.Fcitx5.Addon.Lua
    flatpak install -y fcitx5-unstable org.fcitx.Fcitx5.Addon.Rime
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

echo "开始安装推荐应用..."
install_app com.github.tchx84.Flatseal
install_app com.obsproject.Studio
install_app com.wps.Office
install_app io.mpv.Mpv
install_app net.agalwood.Motrix
install_app org.atheme.audacious
install_app org.blender.Blender
install_app org.gimp.GIMP
install_app org.mozilla.firefox
install_app org.shotcut.Shotcut

read -p "任意键安装更多应用..." -n 1
#install_app io.github.celluloid_player.Celluloid
#install_app net.codeindustry.MasterPDFEditor
#install_app org.geogebra.GeoGebra
#install_app org.kde.kdenlive
#install_app org.kde.krita
#install_app org.stellarium.Stellarium
install_app ch.openboard.OpenBoard
install_app com.github.maoschanz.drawing
install_app com.github.muriloventuroso.pdftricks
install_app com.ozmartians.VidCutter
install_app fr.handbrake.ghb
install_app io.github.cudatext.CudaText-Qt5
install_app io.photoflare.photoflare
install_app nl.hjdskes.gcolor3
install_app org.ardour.Ardour
install_app org.filezillaproject.Filezilla
install_app org.freefilesync.FreeFileSync
install_app org.gnome.Boxes
install_app org.gnome.meld
install_app org.inkscape.Inkscape
install_app org.kde.gwenview
install_app org.kde.index
install_app org.ksnip.ksnip
install_app org.remmina.Remmina
