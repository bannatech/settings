#!/bin/sh

eqn=$(xsel -o -b | rofi -dmenu -p "Calculate")
result=$(printf "%s" "$eqn" | $HOME/.local/bin/calc 2>&1)

printf "%s" "$result" | rofi -dmenu -p "Result" >/dev/null
printf "%s" "$result" | xsel -i -b
