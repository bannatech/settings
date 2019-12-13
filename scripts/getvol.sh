#!/bin/sh

VOL="$(pamixer --get-volume-human)"
AFTER=""
[ "$VOL" = "muted" ] && AFTER="% ♫"
[ "$VOL" = "muted" ] && VOL="0"


printf "%s%s" "$VOL" "$AFTER"

IFS=" "

SED1='s/repeat/r/ ; s/single/s/ ; s/random/z/; s/consume/c/'
SED2='s/volume: [[:digit:]]\{1,2\}%// ; s/[[:alpha:]]: off//g ; s/: on//g'

printf " | "
if [ "$(mpc | wc -l)" -gt 1 ] ; then
  mpc | awk '/^\[/ {print $1}' | tr -d '\n' | sed 's/playing/▶/ ; s/paused/P/'
  printf " "
  mpc | head -n 1 | tr -d '\n'

  mpc | tail -n 1 | grep -q ": on" &&
  mpc | sed -n "$SED1;/volume/p" | sed "$SED2" | tr -d ' ' | xargs printf " [%s]"
fi
