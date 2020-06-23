#!/bin/sh
cd $HOME
xset r rate 290 50
picom &
dunst &
xautolock -time 10 -locker '/usr/bin/i3lock' &
rm -rf $HOME/.cache/dwmbar
$HOME/.local/bin/bar
setxkbmap -layout us -variant dvorak
xmodmap $XDG_CONFIG_HOME/.Xmodmap
sxhkd &
xmodmap .config/.Xmodmap
