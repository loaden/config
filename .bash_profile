# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
    . ~/.bashrc
fi

export PATH="$HOME/.dev/TeXLive/bin/x86_64-linux:$PATH"
export CPLUS_INCLUDE_PATH="$HOME/.dev/Kits/include"
export LIBRARY_PATH="$HOME/.dev/Kits/lib"

export INPUT_METHOD=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx

! result=$( echo $PATH | grep "$HOME/.local/bin" ) && PATH="$HOME/.local/bin:$PATH"
if ! result=$( echo $PATH | grep "$HOME/.local/bin" ) ; then PATH="$HOME/.local/bin:$PATH"; fi

if [[ -f ~/.swayrc ]] ; then
    . ~/.swayrc
fi
