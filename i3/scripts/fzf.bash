#!/bin/bash

# Gather data directories according to
# https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
IFS=: read -r -d '' -a data_dirs < <(printf '%s:\0' "$XDG_DATA_DIRS")
if [ -z "$XDG_DATA_DIRS" ]; then
    data_dirs=("/usr/local/share/" "/usr/share")
fi
if [ -n "$XDG_DATA_HOME" ]; then
    data_dirs+=("$XDG_DATA_HOME")
else
    data_dirs+=("$HOME/.local/share")
fi

# Gather .desktop files
fzf_data=""
for d in "${data_dirs[@]}"; do
    if [ -d "$d/applications" ]; then
        fzf_data+=$(grep -R "^Name" "$d/applications" | sort -u -t: -k1,1 | sed -e "s/Name.*=//")
        fzf_data+=$'\n'
    fi
done

selected=$(echo "$fzf_data" | fzf --delimiter=":" --with-nth=2.. --reverse | sed -e "s/:.*//")
if [ -n "$selected" ]; then
    gtk-launch "$(basename "$selected")"
fi
