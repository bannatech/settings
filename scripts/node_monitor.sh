#!/bin/sh

. $HOME/.config/dmenurc

name=$(bspc query -M --names | dmenu $DOPTS -p "Choose monitor: ")

if test "$name" = "" ; then
    exit 1
fi

bspc node -m "$name" "$1"
