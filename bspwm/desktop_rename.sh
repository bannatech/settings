#!/bin/sh

. $HOME/.config/dmenurc

name=$(dmenu $(echo $DOPTS) -noinput -p "Enter new name: ")

if test "$name" = "" ; then
    exit 1
fi

bspc desktop -n $name
