#!/bin/sh
[ -d /sys/class/power_supply/BAT0 ] || exit 0

PERC=$(cat /sys/class/power_supply/BAT0/capacity)
PLUGGED=$(cat /sys/class/power_supply/ADP0/online)

# emoji dont work for some reason
#[ "$PLUGGED" -eq 1 ] && echo -n "🔌 "
#[ "$PLUGGED" -eq 1 ] || echo -n "🔋 "
echo -n "BAT: "


if [ "$PERC" = "99" ] || [ "$PERC" = "100" ] ; then
  echo "Full"
  exit 0
fi

[ "$PLUGGED" -eq 1 ] && printf "Charging "
echo "$PERC%"
