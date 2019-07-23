#!/bin/sh
VOL="$(pamixer --get-volume-human)"
AFTER=""
[ "$VOL" = "muted" ] && AFTER="% ♫"
[ "$VOL" = "muted" ] && VOL="0"
printf "%s%s" "$VOL" "$AFTER"
