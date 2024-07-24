#!/bin/bash

SCREENSHOT_FILE="/tmp/screenshot.png"
SCREENSHOT_COMMAND="gnome-screenshot -a -f $SCREENSHOT_FILE"

rm -f "$SCREENSHOT_FILE"

$SCREENSHOT_COMMAND

while pgrep -f "$SCREENSHOT_COMMAND" >/dev/null; do
    sleep 0.5
done

if [ ! -f "$SCREENSHOT_FILE" ]; then
    # Screenshot was cancelled
    exit 1
fi

swappy -f "$SCREENSHOT_FILE"
