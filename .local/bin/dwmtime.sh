#!/bin/sh

timef="/tmp/dwmbar.date"
lck="/tmp/dwmbar.lock"

while ! [ -e "$lck" ] ; do
  sleep 1
done

pid="$(cat "$lck")"
date "+%a %e %b %y, %k:%M" > $timef
kill -USR1 "$pid"

while true ; do
  date "+%a %e %b %y, %k:%M" > $timef
  kill -USR1 "$pid"
  sleep $((60 - $(date "+%S")))
done
