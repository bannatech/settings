#!/bin/sh

if Xdialog --wrap --title "Quit bspwm" --yesno "Quit bspwm?" 0 0 ; then
    bspc quit
fi
