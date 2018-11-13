#!/bin/sh

. $HOME/.config/dmenurc

name=$(bspc query -D --names | dmenu $(printf "%s" "$DOPTS") -p "Desktop to remove: ")

if test "$name" = "" ; then
    exit 1
fi

bspc desktop "$name" -r
