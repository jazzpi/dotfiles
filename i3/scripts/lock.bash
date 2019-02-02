#!/bin/bash

# Extract the primary monitor resolution from xrandr
# TODO: What if there is no primary monitor?
res=$(xrandr --listmonitors  | grep '*' | sed -e 's/^ *[^ ]* [^ ]* \([0-9]*\).*x\([0-9]*\).*$/\1x\2/')
# Scaled backgrounds get cached
path="$HOME/.config/i3/.local/backgrounds/background-blur-$res.png"

if [ ! -e "$path" ]
then
    mkdir -p ~/.config/i3/.local/backgrounds
    convert -scale $res ~/.config/i3/theme/background-blur.png "$path"
fi

i3lock -t -f -i "$path"
