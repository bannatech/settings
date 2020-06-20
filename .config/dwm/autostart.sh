#!/bin/sh
cd $HOME
setxkbmap us -variant dvorak
xset r rate 290 50
picom &
dunst &
xautolock -time 10 -locker '/usr/bin/i3lock' &
$HOME/.local/bin/bar
sxhkd &
xmodmap .config/.Xmodmap
