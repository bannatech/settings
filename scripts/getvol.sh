#!/bin/sh
VOL="$(pamixer --get-volume)"
AFTER="%"
[ "$VOL" = "0" ] && AFTER="% ♫"
printf "%s%s" "$VOL" "$AFTER"
