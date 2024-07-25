#!/bin/bash

# Wait for EWW and Dunst to be running so that a tray & notification daemon is
# available
let i=0
while [[ (-z "$(eww active-windows)" || -z "$(pgrep dunst)") && $i -lt 10 ]]; do
    sleep 1
    let i++
done

# Start some applications on startup
thunderbird &
nm-applet &
ibus-daemon -r &
~/.config/i3/scripts/spotify.bash &
signal-desktop &
telegram-desktop &
firefox &
nextcloud &
# Start a terminal on WS 3
i3-msg "workspace $ws3; exec i3-sensible-terminal; workspace $ws1" &
