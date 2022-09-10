#!/bin/bash

swaymsg "output '*' bg \"$(find $HOME/.local/share/wallpaper | shuf -n 1)\" fill"
