#!/bin/bash

CACHE_DIR="$HOME/.config/i3/.local/lock-cache"

# Extract the primary monitor resolution from xrandr
# TODO: What if there is no primary monitor?
res=$(xrandr --listmonitors | grep '*' | sed -e 's/^ *[^ ]* [^ ]* \([0-9]*\).*x\([0-9]*\).*$/\1x\2/')

img=~/.local/share/dotfiles_resources/lockscreen.jpg
img=${img/#\~/$HOME}
# Scaled backgrounds get cached
hash=$(md5sum -b $img | awk '{print $1}')
path="$CACHE_DIR/$hash-$res.png"

if [ ! -e "$path" ]; then
    mkdir -p "$CACHE_DIR"
    convert -scale $res "$img" "$path"
fi

i3lock_args=(
    -f         # Show failed attempts
    -k         # Show clock
    -i "$path" # Image
    -t         # Tiling image
)

ver="$(i3lock --version 2>&1)"
if [[ $ver =~ 'i3lock-color' ]]; then
    i3lock_args+=(
        --indicator # Always show indicator
        --{time,date,layout,verif,wrong,greeter}-font="Overpass ExtraLight"
        --{time,date,layout,verif,wrong,greeter}-color=eeeeeeff
        -F # Zoom image to screen size (without stretching)
    )
fi

i3lock "${i3lock_args[@]}"
