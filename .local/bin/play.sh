#!/bin/sh

url=$(xsel -o -b | rofi -dmenu -p "Play with mpv")
if ! mpv "$url" >/dev/null ; then
    printf "" | rofi -dmenu -p "Error playing $url" > /dev/null
fi
