#!/bin/sh

sender=$1
summary=$2
body=$3
urgency=$5$4
text=$(echo $body | cut -c-10)

if ! test "$text" = "$3" ; then
    text=$text'...'
fi

title=$(echo "$summary" | sed -re 's/ .+//')

if test "$urgency" = "" ; then
    urgency="N"
fi

urgency=$(echo $urgency | head -c 1)

printf '[%s] %s: %s [%s]' "$sender" "$title" "$text" "$urgency" > /tmp/polybar_ipc

polybar-msg hook ipc 1
polybar-msg hook ipc 2
