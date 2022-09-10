#!/bin/zsh

[ -f "$XDG_CONFIG_HOME/bookmarks" ] || exit 1

[ -f "~/.zprofile" ] &&  source ~/.zprofile
[ -f "$XDG_CONFIG_HOME/zsh/.zshrc" ] && source $XDG_CONFIG_HOME/zsh/.zshrc

place=$(grep -ve "^$" -e "^#" "$XDG_CONFIG_HOME/bookmarks" | cut -f1 | rofi -dmenu "Choose bookmark:")

if ! grep -q "^$place" "$XDG_CONFIG_HOME/bookmarks" 2>/dev/null ; then
  rofi -e "$place not found"
  exit 1
fi

loc="$(grep "^$place" "$XDG_CONFIG_HOME/bookmarks" | cut -f2)"
# EVIL used for indirection, input only from my file, it would be bad if attacker had w access to .config
loc="$(eval echo "$loc")"

[ "$#" -ge 1 ] || kitty -d "$loc"
[ "$#" -ge 1 ] && kitty -d "$loc" zsh -c $@
