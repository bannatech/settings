#!/bin/sh

# $1 is volume
# $2 is sink (optional)

if [ "$1" = "" ] ; then
    exit 1
fi

if ! [ "$2" = "" ] ; then
    sink="$2"
fi

if [ -n "$2" ] ; then
    alias pamixer=pamixer --sink "$2" 
fi

current_vol=$(pamixer --get-volume)

op=$(printf "%s" "$1" | head -c 1)
operand="${1#?}"


case "$op" in
    "+")
        operand=$(printf "%s %s" "$current_vol" "$operand" | awk '{print $1 + $2}')
    ;;
    "-")
        operand=$(printf "%s %s" "$current_vol" "$operand" | awk '{print $1 - $2}')
    ;;
    "m")
        pamixer -m
        exit 0
    ;;
    "u")
        pamixer -u
        exit 0
    ;;
    "t")
        pamixer -t
        exit 0
    ;;
    "a")
        operand=$(printf "%s" "$current_vol" | rofi -dmenu -p "Enter volume")
    ;;
    *)
        operand=$1
    ;;
esac

[ -n "$operand" ] && pamixer --set-volume "$operand"
