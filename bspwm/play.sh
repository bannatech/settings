#!/bin/sh

. $HOME/.config/dmenurc

url=$(xsel -o -b | dmenu $(printf "%s" "$DOPTS") -p "Play with mpv: ")
if ! mpv "$url" >/dev/null ; then
    dmenu -noinput $(printf "%s" "$DOPTS") -p "Error playing $url" > /dev/null
fi
