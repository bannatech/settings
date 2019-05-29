#!/bin/sh

temps="$(curl http://wttr.in/?0QTA 2>/dev/null | grep "°" | sed --posix -e \
  's/\(-\{0,1\}[0-9][0-9]\{0,2\}\)\.\.\(-\{0,1\}[0-9][0-9]\{0,2\}\)/\n\1\n\2\n/' | \
  grep "[0-9]" | xargs printf "%s %s")"

low="$(printf "%s" "$temps" | cut -d " " -f 1)"
high="$(printf "%s" "$temps" | cut -d " " -f 2)"

avg="$(( ( "$low" + "$high" ) / 2 ))"
printf "%s°F" "$avg"
