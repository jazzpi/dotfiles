#!/bin/bash

I3_THEME_DIR="$HOME/.config/i3/themes"
I3_LOCAL_DIR="$HOME/.config/i3/.local"

function usage {
    >&2 echo "Usage: ${BASH_SOURCE[0]} (load|install_only THEME)|reload"
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

function install_theme {
    if [ ! -f "$I3_THEME_DIR/$1" ]; then
        echo "Theme `$1` does not exist!"
        exit 1
    fi

    mkdir -p "$I3_LOCAL_DIR"
    ln -s -f "$I3_THEME_DIR/$1" "$I3_LOCAL_DIR/current-theme"
}

function reload_theme {
    xrdb -override "$I3_LOCAL_DIR/current-theme"
    &>/dev/null pgrep i3 && i3-msg reload
}

case "$1" in
"load")
    if [ "$#" -ne 2 ]; then
        usage
    fi
    install_theme "$2"
    reload_theme
    ;;
"reload")
    if [ "$#" -ne 1 ]; then
        usage
    fi
    reload_theme
    ;;
"install_only")
    if [ "$#" -ne 2 ]; then
        usage
    fi
    install_theme "$2"
    ;;
*)
    usage
    ;;
esac
