#!/bin/sh

. $HOME/.config/dmenurc

eqn=$(xsel -o -b | dmenu $DOPTS -p "Calculate (julia): ")
result=$(julia -E "$eqn")

printf "%s" "$result" | dmenu $DOPTS -p "Result: " >/dev/null
printf "%s" "$result" | xsel -i -b
