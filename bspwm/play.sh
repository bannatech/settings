#!/bin/sh

. $HOME/.config/dmenurc

url=$(xsel -o -b | dmenu $DOPTS -p "Play with mpv: ")
if ! mpv "$url" >/dev/null ; then
    dmenu -noinput $DOPTS -p "Error playing $url" > /dev/null
fi
