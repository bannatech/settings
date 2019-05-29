#!/bin/sh

timef="$(mktemp)"

cd $HOME

while true ; do
  date "+%a %e %b %y, %k:%M" > "$timef"
  sleep 60
done &


while true ; do
  function killsub() {
    kill -9 ${!} 2>/dev/null
  }
  TIME="$(cat "$timef")"
  BAT="$(./.scripts/getbattery.sh)"
  VOL="$(./.scripts/getvol.sh)"
  BAR="$(printf " %s | Bat: %s | Vol: %s" "$TIME" "$BAT" "$VOL" )"
  xsetroot -name "$BAR"
  trap "killsub" SIGUSR1
  sleep 10 & wait ${!}
done &
