#!/bin/sh

timef="$(mktemp)"

while true ; do
  date "+%a %e %b %y, %k:%M" > "$timef"
  sleep 60
done &

while true ; do
  TIME="$(cat "$timef")"
  BAT="$(getbattery.sh)"
  VOL="$(getvol.sh)"
  BAR="$(printf " %s | Bat: %s | Vol: %s" "$TIME" "$BAT" "$VOL" )"
  xsetroot -name "$BAR"
  sleep 10
done &
