#!/bin/sh

. $HOME/.config/dmenurc

name="$1"
remove="yes"
if test "$name" = "" || test "$name" = "default" ; then
    name=$(mktemp /tmp/shotXXXXXXXXX.png)
    rm $(name)
    remove="yes"
elif test "$name" = "ask"; then
    name=$(dmenu -noinput $(printf "%s" "$DOPTS") -p "Screenshot name: ")
    remove="no"
fi

if ! grep "\.png" >/dev/null ; then
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


if test "$mode" = "-s" ; then
    dmenu -noinput $(printf "%s" "$DOPTS") -p "Select an area: " >/dev/null
elif test "$mode" = "-u" ; then
    dmenu -noinput $(printf "%s" "$DOPTS") -p "Capturing focused window..." >/dev/null
else
    dmenu -noinput $(printf "%s" "$DOPTS") -p "Capturing full screen..." > /dev/null
fi

scrot "$name" $mode

if test "$remove" = "yes" ; then
    cat "$name" | xclip -selection clipboard -t image/png
    rm "$name"
fi
