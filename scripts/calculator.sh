#!/bin/sh

. $HOME/.config/dmenurc

eqn=$(xsel -o -b | dmenu $DOPTS -p "Calculate (bc): ")
result=$(printf "scale = 5 \n %s\n" "$eqn" | bc | sed -e 's/\.\{0,1\}0\+$//')

printf "%s" "$result" | dmenu $DOPTS -p "Result: " >/dev/null
printf "%s" "$result" | xsel -i -b
