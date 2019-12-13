#!/bin/sh

VOL="$(pamixer --get-volume-human)"
AFTER=""
[ "$VOL" = "muted" ] && AFTER="% ♫"
[ "$VOL" = "muted" ] && VOL="0"


printf "%s%s" "$VOL" "$AFTER"

IFS=" "

printf " | "
if [ "$(mpc | wc -l)" -gt 1 ] ; then
  mpc | awk '/^\[/ {print $1}' | tr -d '\n' | sed 's/playing/▶/ ; s/paused/P/'
  printf " "
  mpc | head -n 1 | tr -d '\n'
  ATTR=""
  if mpc | grep -q "repeat: on" ; then
    ATTR="$ATTR"r
  fi
  if mpc | grep -q "random: on" ; then
    ATTR="$ATTR"z
  fi
  if mpc | grep -q "single: on" ; then
    ATTR="$ATTR"s
  fi
  if mpc | grep -q "consume: on" ; then
    ATTR="$ATTR"c
  fi

  test "$ATTR" && printf " [%s]" "$ATTR"
fi
