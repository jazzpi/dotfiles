#!/bin/bash

if [ -f /tmp/i3-background.pid ]; then
    kill $(cat /tmp/i3-background.pid)
    rm /tmp/i3-background.pid
fi
echo "$BASHPID" >/tmp/i3-background.pid

(
    echo initial
    i3-msg -t subscribe -m '[ "output" ]'
) | while IFS='' read line; do
    nohup feh --bg-fill --no-fehbg ~/.local/share/dotfiles_resources/wallpaper.jpg &
done
