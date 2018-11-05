#!/bin/sh

. $HOME/.config/dmenurc

name=$(bspc query -D --names | dmenu $(echo $DOPTS) -p "Desktop name: ")

if test "$name" = "" ; then
   exit 1
fi

# Check if the desktop already exists
if bspc query -D --names | grep $name >/dev/null ; then
    # Desktop exists
    bspc desktop -f $name
else
    # Desktop does not exist
    bspc monitor -a $name
    bspc desktop -f $name
fi
