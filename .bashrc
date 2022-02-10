# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
export PATH="$HOME/.dev/TeXLive/bin/x86_64-linux:$PATH"
export CPLUS_INCLUDE_PATH="$HOME/.dev/Kits/include:$CPLUS_INCLUDE_PATH"
export LIBRARY_PATH="$HOME/.dev/Kits/lib:$LIBRARY_PATH"

! result=$( echo $PATH | grep "$HOME/.local/bin" ) && PATH="$HOME/.local/bin:$PATH"

if ! result=$( echo $PATH | grep "$HOME/.local/bin" ) ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export XMODIFIERS=@im=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export SDL_IM_MODULE=fcitx5
export MOZ_DBUS_REMOTE=1
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway