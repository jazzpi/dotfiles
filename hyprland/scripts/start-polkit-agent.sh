#!/bin/bash

declare -a possible_paths=(
    "/usr/lib/polkit-kde-authentication-agent-1"
    "/usr/libexec/kf5/polkit-kde-authentication-agent-1"
    "/usr/libexec/polkit-gnome-authentication-agent-1"
)

for path in "${possible_paths[@]}"; do
    if [ -x "$path" ]; then
        exec "$path"
    fi
done

notify-send -u critical "No polkit agent found"
