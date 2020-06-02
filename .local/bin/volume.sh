#!/bin/sh

# $1 is volume
# $2 is sink (optional)

lck="$HOME/.cache/dwmbar/bar.pid"

while ! [ -e "$lck" ] ; do
  sleep 1
done

pid="$(cat "$lck")"

if [ "$1" = "" ] ; then
    exit 1
fi

sink="$(pamixer --list-sinks | awk '/Built/ {print $1}')"
if ! [ "$2" = "" ] ; then
    sink="$2"
fi

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
  kill -ALRM "$pid"
	exit 0
	;;
    "u")
	pamixer --sink $sink -u
  kill -ALRM "$pid"
	exit 0
	;;
    "t")
	pamixer --sink $sink -t
  kill -ALRM "$pid"
	exit 0
	;;
    "a")
	operand=$(printf "%s" "$current_vol" | rofi -dmenu -p "Enter volume")
	;;
    *)
	operand=$1
	;;
esac

if [ "$operand" = "" ] ; then
    exit 0
fi

pamixer --sink "$sink" --set-volume "$operand" 2>/dev/null >/dev/null
kill -ALRM "$pid" 2>/dev/null >/dev/null
