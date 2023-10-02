#!/bin/bash

export VAULT_NAMESPACE="admin"

tmp="$(mktemp /tmp/XXXXX)"

cd "$HOME"
find ".local/share/password-store" -type f | grep -v ".git" > "$tmp"

while read line; do
    password="$(gpg --decript $line 2>/dev/null)"
    name="$(echo "$line" | sed 's_.local/share/password-store/__' | sed 's/\.gpg$//')"
    data="$(gpg --decrypt $line 2>/dev/null)"
    vault kv put "secret/password-store/$name" "data=$data"
done < $tmp

rm $tmp
