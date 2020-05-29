#!/bin/sh
cd $HOME
setxkbmap us -variant dvorak
xmodmap $HOME/.Xmodmap
xset r rate 290 50
fcitx &
compton &
dunst &
xautolock -time 10 -locker '/usr/bin/i3lock' &
./.scripts/bar
sxhkd &
