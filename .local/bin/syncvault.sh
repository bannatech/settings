#!/bin/bash

export VAULT_NAMESPACE="admin"

cd "$HOME" || exit
shopt -s globstar

for line in .local/share/password-store/**/*; do
    grep -q ".git" <<< "$line" && continue
    name="$(echo "$line" | sed 's_.local/share/password-store/__' | sed 's/\.gpg$//')"
    data="$(gpg --decrypt "$line" 2>/dev/null)"
    vault kv put "secret/password-store/$name" "data=$data"
done
