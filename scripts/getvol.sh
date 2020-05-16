#!/bin/sh

VOL="$(pamixer --get-volume-human)"
AFTER=""
[ "$VOL" = "muted" ] && AFTER="% ♫"
[ "$VOL" = "muted" ] && VOL="0"

printf "%s%s" "$VOL" "$AFTER"

if ! mpc >/dev/null 2>&1 ; then
  exit 0
fi

if [ "$(mpc | wc -l)" -eq "1" ] ; then
  exit 0
fi

IFS=" "

SED1='s/repeat/r/ ; s/single/s/ ; s/random/z/; s/consume/c/'

printf " | "
if [ "$(mpc | wc -l)" -gt 1 ] ; then
  mpc | awk '/^\[/ {print $1}' | tr -d '\n' | sed 's/playing/▶/ ; s/paused/P/'
  printf " "
  mpc | head -n 1 | cut -c-25 | tr -d '\n'

  mpc | tail -n 1 | grep -q ": on" &&
    mpc | sed -n "$SED1;/volume/p" | \
    sed 's/volume: [[:digit:]]\{1,2\}%// ; s@volume: n/a@@ ; s/[[:alpha:]]: off//g ; s/: on//g' \
    | tr -d ' ' | xargs printf " [%s]"
fi
