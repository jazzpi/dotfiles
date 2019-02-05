#!/bin/bash

if command -v i3-dmenu-desktop &>/dev/null; then
    if command -v fzf &>/dev/null; then
        echo "Running fzf"
        i3-dmenu-desktop --dmenu='~/.config/i3/scripts/fzf.bash'
    else
        echo "Running i3-dmenu-desktop"
        i3-dmenu-desktop
    fi
else
    echo "Running dmenu_run"
    dmenu_run
fi
