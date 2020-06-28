#!/bin/sh
cd $HOME
picom &
dunst &
xautolock -time 10 -locker "$HOME/.local/bin/locker.sh" &
xmodmap $XDG_CONFIG_HOME/.Xmodmap
xset r rate 290 50
dwmblocks &
sxhkd -m 2 &
ckb-next -b &
$HOME/.local/bin/readqueue.sh &
