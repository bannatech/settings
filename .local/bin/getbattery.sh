#!/bin/sh
[ -d /sys/class/power_supply/BAT0 ] || exit 0

PERC=$(cat /sys/class/power_supply/BAT0/capacity)
PLUGGED=$(cat /sys/class/power_supply/ADP0/online)

[ "$PLUGGED" -eq 1 ] && printf "🔌 "
[ "$PLUGGED" -eq 1 ] || printf "🔋 "


if [ "$PERC" = "99" ] || [ "$PERC" = "100" ] ; then
  printf "Full"
  exit 0
fi

[ "$PLUGGED" -eq 1 ] && printf "Charging "
printf "%s%%" "$PERC"
