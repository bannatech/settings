#!/bin/sh

if Xdialog --wrap --title "Quit dwm" --yesno "Quit dwm?" 0 0 ; then
  pkill dwm
fi
