#!/bin/bash

marks=$(swaymsg -t get_marks | sed -e 's/\[//;s/"//g;s/,/ /g;s/\]//;1d;$d;s/^ \+//' | tr -d '\n')
echo "Jump to [$marks]: " | xxd
echo "" | dmenu -p "Jump to [$marks]: " | xargs -i -r swaymsg '[con_mark=' {} ']' focus
