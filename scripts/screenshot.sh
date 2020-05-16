#!/bin/sh

name="$1"
remove="yes"
if [ "$name" = "" ] || [ "$name" = "default" ] ; then
    name=$(mktemp /tmp/shotXXXXXXXXX.png)
    rm $(name)
    remove="yes"
elif [ "$name" = "ask" ] ; then
  name=$(printf "" | rofi -dmenu -p "Screenshot name")
    remove="no"
fi

if ! printf "%s" "$name" | grep "\.png" >/dev/null ; then
    name="$name.png"
fi

mode="$2"
case "$mode" in
    "")
	mode="-s"
	;;
    "none")
	mode=""
	;;
    "full")
	mode=""
	;;
    "selectt")
	mode="-s"
	;;
    "focused")
	mode="-u"
	;;
    "u")
	mode="-u"
	;;
    *)
	exit 1
	;;
esac


if [ "$mode" = "-s" ] ; then
  printf "" | rofi -dmenu -p "Select an area" >/dev/null
elif [ "$mode" = "-u" ] ; then
  sleep 1
else
  sleep 1
fi

scrot "$name" $mode

if [ "$remove" = "yes" ] ; then
  cat "$name" | xclip -selection clipboard -t image/png
  rm "$name"
fi
