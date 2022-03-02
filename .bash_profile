# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

export PATH="$HOME/.dev/TeXLive/bin/x86_64-linux:$PATH"
export CPLUS_INCLUDE_PATH="$HOME/.dev/Kits/include:$CPLUS_INCLUDE_PATH"
export LIBRARY_PATH="$HOME/.dev/Kits/lib:$LIBRARY_PATH"

! result=$( echo $PATH | grep "$HOME/.local/bin" ) && PATH="$HOME/.local/bin:$PATH"

if ! result=$( echo $PATH | grep "$HOME/.local/bin" ) ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export MOZ_DBUS_REMOTE=1

[ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && dbus-run-session sway
#[ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && exec sway
