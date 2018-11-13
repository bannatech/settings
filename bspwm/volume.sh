#!/bin/sh

# $1 is volume
# $2 is sink (optional)

if test "$1" = "" ; then
    exit 1
fi

sink=1
if ! test "$2" = "" ; then
    sink="$2"
fi

. $HOME/.config/dmenurc

current_vol=$(pamixer --get-volume --sink "$sink")

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
	pamixer --sink $sink -m
	exit 0
	;;
    "u")
	pamixer --sink $sink -u
	exit 0
	;;
    "t")
	pamixer --sink $sink -t
	exit 0
	;;
    "a")
	operand=$(printf "%s" "$current_vol" | dmenu $(printf "%s" "$DOPTS") -p "Enter volume: ")
	;;
    *)
	operand=$1
	;;
esac

if test "$operand" = "" ; then
    exit 0
fi

pamixer --sink "$sink" --set-volume "$operand" 2>/dev/null >/dev/null
