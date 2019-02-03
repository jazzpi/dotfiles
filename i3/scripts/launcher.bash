#!/bin/bash

if command -v fzf &>/dev/null; then
    echo "Running fzf"
    xterm -fa "DejaVu Sans Mono" -fs 9 -bg black -fg white -class fzf -e "$HOME/.config/i3/scripts/fzf.bash"
elif command -v i3-dmenu-desktop &>/dev/null; then
    echo "Running i3-dmenu-desktop"
    i3-dmenu-desktop
else
    echo "Running dmenu_run"
    dmenu_run
fi
