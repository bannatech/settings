#!/bin/sh

. $HOME/.config/dmenurc

eqn=$(xsel -o -b | dmenu $DOPTS -p "Calculate (dc): ")
result=$(printf "5 k %s p" "$eqn" | dc)

printf "%s" "$result" | dmenu $DOPTS -p "Result: " >/dev/null
printf "%s" "$result" | xsel -i -b
