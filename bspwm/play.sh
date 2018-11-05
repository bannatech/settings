#!/bin/sh

. $HOME/.config/dmenurc

url=$(xsel -o -b | dmenu $(echo $DOPTS) -p "Play with mpv: ")
if ! mpv "$url" >/dev/null ; then
    dmenu -noinput $(echo $DOPTS) -p "Error playing $url">/dev/null
fi
