#!/bin/bash

marks=$(swaymsg -t get_marks | sed -e 's/\[//;s/"//g;s/,/|/g;s/\]//;1d;$d;s/^ \+//' | tr -d '\n')
echo "Jump to [$marks]: " | xxd
echo "$marks" | rofi -dmenu -sep '|' -p "Jump to [$marks]: " -only-match | xargs -i -r swaymsg '[con_mark=' {} ']' focus
