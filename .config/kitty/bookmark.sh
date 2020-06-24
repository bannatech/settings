#!/bin/sh
OUT="$XDG_CONFIG_HOME/kitty/bookmarks.conf"
IN="$XDG_CONFIG_HOME/bookmarks"
PREFIX="map kitty_mod+m>"

[ -f "$IN" ] || exit 0
rm -f "$OUT"

bfile="$(mktemp "$XDG_RUNTIME_DIR/tmp.XXXXXXX")"
chmod 600 "$bfile"

# change the bookmarks to have the > between each one
# couldn't figure out how to do it in sed and POSIX w/o temp
grep -ve "^$" -e "^#" "$IN" | cut -f1 |\
  sed 's/\(.\)/\1>/g ; s/^/'"$PREFIX"'/ ; s/>$//' > "$bfile"

grep -ve "^$" -e "^#" "$IN" | cut -f2 |\
  sed 's/^/launch --cwd="/ ; s/$/"/' |\
  paste -d' ' "$bfile" - >> "$OUT"
echo >> "$OUT"

sed 's/kitty_mod/kitty_mod+alt/ ; s/launch/launch --type=tab/' "$OUT" > "$bfile"
cat "$bfile" >> "$OUT"
rm "$bfile"

