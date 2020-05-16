#!/bin/sh

if [ "$1" = "__kill" ] ; then
    pkill -15 ffmpeg
    exit 0
fi

if ps -x | grep "ffcast" | grep -v "grep" >/dev/null; then
    exit 1
fi

TMP_AVI=$(mktemp /tmp/outXXXXXXXXXX.avi)

output=$1
if [ "$output" = "" ] || [ "$output" = "default" ] ; then
    output=$(date +%F-%T)'_screencast'
fi

if [ "$output" = "ask" ] ; then
    output=$(printf "" | rofi -dmenu -p "Name screencast")
fi

mode=$2
if [ "$mode" = "" ] || [ "$mode" = "default" ] ; then
    mode="s"
fi

format=$3
if [ "$format" = "" ] || [ "$format" = "default" ] ; then
    format="mp4"
fi

if [ "$format" = "ask" ] ; then
    format=$(echo "mpv" | rofi -dmenu -p "Select video format")
fi

if printf "%s" "$output" | grep "\." >/dev/null; then
    format=$(printf "%s" "$output" | sed -re 's/\./\n/' | tail -n 1)
    output=$(printf "%s" "$output" | sed -re "s/\.[^\.]+\$//")
fi

framerate=$4
if [ "$framerate" = "" ] || [ "$framerate" = "default" ] ; then
    framerate="15"
fi

if [ "$framerate" = "ask" ] ; then
    framerate=$(echo "15" | rofi -dmenu -p "Choose framerate")
fi

case "$mode" in
    "s")
	mode="s"
	;;
    "select")
	mode="s"
	;;
    "w")
	mode="w"
	;;
    "window")
	mode="w"
	;;
    *)
	echo "Invalid mode" >&2
	exit 1
esac

ffcast -$mode % ffmpeg -y -f x11grab -show_region 1 -framerate $framerate \
       -video_size %s -i %D+%c -codec:v huffyuv -vf crop="iw-mod(iw\\,2):ih-mod(iw\\,2)" \
       "$TMP_AVI"

ffmpeg -i "$TMP_AVI" "$output.$format"

if [ "$format" = "gif" ] ; then
    convert -limit memory 1 -limit map 1 -layers Optimize "$output.$format" "opt_$output.$format"
    rm "$output.$format"
    mv "opt_$output.$format" "$output.$format"
fi

rm "$TMP_AVI"
