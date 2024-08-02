#!/bin/bash

# What directory is this script in?
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if ! configs=$("$DIR/randr.bash" list); then
    i3-nagbar -m 'No configurations exist!'
    exit 1
fi

cfg=$(echo "$configs" | rofi -dmenu -sep ' ' -p "Restore from [$configs]:")
if [ -z "$cfg" ]; then
    exit 1
fi
"$DIR/randr.bash" restore "$cfg"
