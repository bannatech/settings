#!/bin/sh

. $HOME/.config/dmenurc

eqn=$(xsel -o -b | dmenu $(echo $DOPTS) -p "Calculate (julia): ")
result=$(julia -E "$eqn")

echo "$result" | dmenu $(echo $DOPTS) -p "Result: " >/dev/null
echo "$reslt" | xsel -i -b
