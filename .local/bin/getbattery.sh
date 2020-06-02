#!/bin/sh
PERC=$(acpi | cut -d " " -f 4 | tr -d "%," )
CHRG=$(acpi | cut -d " " -f 3 | tr -d "," | sed 's/Unknown/Charging/')

if [ "$PERC" = "99" ] || [ "$PERC" = "100" ] ; then
  printf "Full"
  exit 0
fi

printf "%s %s%%" "$CHRG" "$PERC"
