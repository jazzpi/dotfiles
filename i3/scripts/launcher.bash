#!/bin/bash

DMENU_CMD=dmenu_run
DMENU_OPTIONS=""
if command -v j4-dmenu-desktop &>/dev/null; then
    DMENU_CMD=j4-dmenu-desktop
    DMENU_OPTIONS="--no-generic --display-binary"
elif command -v i3-dmenu-desktop &>/dev/null; then
    DMENU_CMD=i3-dmenu-desktop
fi
if [ "$DMENU_CMD" != "dmenu_run" ] && command -v fzf &>/dev/null; then
    DMENU_OPTIONS="$DMENU_OPTIONS --dmenu=~/.config/i3/scripts/fzf.bash"
fi

echo "$DMENU_CMD" $DMENU_OPTIONS

"$DMENU_CMD" $DMENU_OPTIONS
