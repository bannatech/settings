#!/bin/sh

layout="$1"

if test "$layout" = "" ; then
    exit 1
fi

if test "$layout" = "qwerty" ; then
    layout="us"
fi

case "$layout" in
    "us")
    ;;
    "dvorak")
    ;;
    *)
	exit 1
	;;
esac

setxkbmap "$layout"

rm $HOME/.config/sxhkd/sxhkdrc

if test "$layout" = "us" ; then
    cp $HOME/.config/sxhkd/sxhkdrc_qwerty $HOME/.config/sxhkd/sxhkdrc
else
    cp $HOME/.config/sxhkd/sxhkdrc_dvorak $HOME/.config/sxhkd/sxhkdrc
fi

systemctl --user restart sxhkd.service
