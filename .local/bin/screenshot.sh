#!/bin/sh

name="$1"
remove="yes"
if [ "$name" = "" ] || [ "$name" = "default" ] ; then
    name=$(mktemp /tmp/shotXXXXXXXXX.png)
    rm $name
    remove="yes"
elif [ "$name" = "ask" ] ; then
  name=$(printf "" | rofi -dmenu -p "Screenshot name")
    remove="no"
fi

if ! printf "%s" "$name" | grep "\.png" >/dev/null ; then
    name="$name.png"
fi

grim -g "$(slurp)" "$name"

if [ "$2" = "copy" ]; then
  url="$(curl --upload-file "$name" https://file.aftix.xyz)"
  rofi -dmenu -p "URL: $url"
  echo -n "$url" | xsel -ib
  [ "$remove" = yes ] && rm "$name"
elif [ "$remove" = "yes" ] ; then
  cat "$name" | xclip -selection clipboard -t image/png
  rm "$name"
fi
