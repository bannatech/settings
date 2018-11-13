#!/bin/sh

. $HOME/.config/dmenurc

name=$(bspc query -D --names | dmenu $(printf "%s" "$DOPTS") -p "Desktop to send to: ")

if test "$name" = ""  ; then
    exit 1
fi

# Make desktop if it doenst exist
if ! bspc query -D --names | grep "$name" >/dev/null; then
    bspc monitor -a "$name"
fi

bspc node -d "$name" "$1"
