#!/bin/sh

VOL="$(pamixer --get-volume-human)"

if [ "$VOL" = "muted" ] ; then
  printf "🔇"
  exit 0
fi

if [ "${VOL%%%}" -ge 66 ] ; then
  echo -n "🔊"
elif [ "${VOL%%%}" -ge 33 ]; then
  echo -n "🔉"
else
  echo -n "🔈"
fi

echo "$VOL"

