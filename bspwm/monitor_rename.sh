#!/bin/sh

. $HOME/.config/dmenurc

name=$(bspc query -M -m focused --names | dmenu $DOPTS -p "Enter new monitor name: ")

if test "$name" = "" ; then
    exit 1
fi

bspc monitor -n "$name"
