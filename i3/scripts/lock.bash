#!/bin/bash

CACHE_DIR="$HOME/.config/i3/.local/lock-cache"

# Extract the primary monitor resolution from xrandr
# TODO: What if there is no primary monitor?
res=$(xrandr --listmonitors  | grep '*' | sed -e 's/^ *[^ ]* [^ ]* \([0-9]*\).*x\([0-9]*\).*$/\1x\2/')

img=$(sed -e '/i3wm\.lockscreen_image/s/[^:]*: //p' -n ~/.config/i3/.local/current-theme/resources)
img=${img/#\~/$HOME}
# Scaled backgrounds get cached
hash=$(md5sum -b $img | awk '{print $1}')
path="$CACHE_DIR/$hash-$res.png"

if [ ! -e "$path" ]
then
    mkdir -p "$CACHE_DIR"
    convert -scale $res "$img" "$path"
fi

i3lock -t -f -i "$path"
