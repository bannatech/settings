#!/bin/sh
cd $HOME
picom &
dunst &
xautolock -time 10 -locker '/usr/bin/i3lock' &
xmodmap $XDG_CONFIG_HOME/.Xmodmap
xset r rate 290 50
dwmblocks &
sxhkd -m 2 &
