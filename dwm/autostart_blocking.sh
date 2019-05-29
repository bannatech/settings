#!/bin/sh
cd $HOME
numlockx on
xset -dpms
xset -b
feh --randomize --bg-scale ~/.wallpaper/*
setxkbmap -option "compose:caps"
