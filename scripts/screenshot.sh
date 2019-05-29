#!/bin/sh

. $HOME/.config/dmenurc

name="$1"
remove="yes"
if [ "$name" = "" ] || [ "$name" = "default" ] ; then
    name=$(mktemp /tmp/shotXXXXXXXXX.png)
    rm $(name)
    remove="yes"
elif [ "$name" = "ask" ] ; then
  name=$(printf "" | dmenu $DOPTS -p "Screenshot name: ")
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
    printf "" | dmenu $DOPTS -p "Select an area: " >/dev/null
elif [ "$mode" = "-u" ] ; then
    printf "" | dmenu $DOPTS -p "Capturing focused window..." >/dev/null
else
    printf "" | dmenu $DOPTS -p "Capturing full screen..." > /dev/null
fi

scrot "$name" $mode

if [ "$remove" = "yes" ] ; then
    cat "$name" | xclip -selection clipboard -t image/png
    rm "$name"
fi
