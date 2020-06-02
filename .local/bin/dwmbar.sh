#!/bin/sh

timef="/tmp/dwmbar.date"
lck="/tmp/dwmbar.lock"

cd $HOME

date "+%a %e %b %y, %k:%M" > "$timef"
echo "$$" > "$lck"

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
  trap "killsub" SIGUSR2
  sleep 1000 & wait ${!}
done
