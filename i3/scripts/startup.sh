#!/bin/bash

poll() {
    timeout=$1
    shift
    while ! eval "$@" && ((timeout-- > 0)); do
        sleep 1
    done
    ((!timeout))
}

set -x

# First, picom needs to run so other apps can use transparency
poll 10 "pgrep -f picom" || true
sleep 1
# Then, EWW and Dunst need to run so that the tray and notifications are available
~/.config/eww/scripts/wm.sh launch &
poll 10 '[ -z "$(eww active-windows)" -o -z "$(pgrep dunst)" ]' || true
sleep 1

# Then, we can start the rest of the applications
thunderbird &
nm-applet --indicator &
ibus-daemon -r &
~/.config/i3/scripts/spotify.bash &
signal-desktop &
telegram-desktop &
firefox &
nextcloud &
# Start a terminal on WS 3
i3-msg "workspace $ws3; exec i3-sensible-terminal; workspace $ws1" &
