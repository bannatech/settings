#!/bin/sh

while [ "1" = "1" ] ; do
  PERC=$(acpi | cut -d " " -f 4 | tr -d ",%")
  CHRG=$(acpi | cut -d " " -f 3 | tr -d ",")
  echo $CHRG
  if [ "$PERC" -le "20" ] && [ "$CHRG" = "Discharging" ] ; then
    notify-send -u critical "Battery Low" "Battery is at ${PERC}% capacity - consider charging"
  fi
  sleep 300
done
