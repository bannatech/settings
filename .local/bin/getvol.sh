#!/bin/sh

VOL="$(pamixer --get-volume-human)"

if [ "$VOL" = "muted" ] ; then
  echo -n "🔇"
  exit 0
fi

# emoji dont work in dwmblocks for some reason
if [ "${VOL%%%}" -ge 66 ] ; then
  echo -n "🔊"
elif [ "${VOL%%%}" -ge 33 ]; then
 echo -n "🔉"
else
 echo -n "🔈"
fi

echo " ${VOL%%%}%"

