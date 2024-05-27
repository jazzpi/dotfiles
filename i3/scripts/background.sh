#!/bin/bash

if [ $# -ne 1 ]; then
    echo >&2 "Usage: $0 BG-IMG"
    exit 1
fi

if [ -f /tmp/i3-background.pid ]; then
    kill $(cat /tmp/i3-background.pid)
    rm /tmp/i3-background.pid
fi
echo "$BASHPID" >/tmp/i3-background.pid

(
    echo initial
    i3-msg -t subscribe -m '[ "output" ]'
) | while IFS='' read line; do
    nohup feh --bg-fill --no-fehbg "$1" &
done
