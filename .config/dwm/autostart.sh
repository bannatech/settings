#!/bin/sh
cd $HOME
picom &
dunst &
xautolock -time 10 -locker "$HOME/.local/bin/locker.sh" &
xmodmap $HOME/.config/.Xmodmap
xset r rate 290 50
dwmblocks &
sxhkd -m 2 &
udiskie &
$HOME/.local/bin/readqueue.sh &
