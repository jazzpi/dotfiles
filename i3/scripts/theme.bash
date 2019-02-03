#!/bin/bash

I3_THEME_DIR="$HOME/.config/i3/themes"
I3_LOCAL_DIR="$HOME/.config/i3/.local"

function usage {
    >&2 echo "Usage: ${BASH_SOURCE[0]} (list|reload) | load [THEME] | install_only THEME"
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

function install_theme {
    if [ ! -f "$I3_THEME_DIR/$1/resources" ]; then
        echo "Theme `$1` does not exist!"
        exit 1
    fi

    mkdir -p "$I3_LOCAL_DIR"
    ln -s -f "$I3_THEME_DIR/$1/resources" "$I3_LOCAL_DIR/current-theme"
}

function reload_theme {
    xrdb -override "$I3_LOCAL_DIR/current-theme"
    &>/dev/null pgrep i3 && i3-msg reload
}

function list_themes {
    [ -d "$I3_THEME_DIR" ] && ls "$I3_THEME_DIR" | paste -sd " " -
}

case "$1" in
"load")
    if [ "$#" -eq 1 ]; then
        if ! themes=$(list_themes); then
            i3-nagbar -m "No themes exist!?"
            exit 1
        fi
        i3-input -F "exec '${BASH_SOURCE[0]}' load '%s'" -P "Load [$themes]:"
    elif [ "$#" -ne 2 ]; then
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
"list")
    if [ "$#" -ne 1 ]; then
        usage
    fi
    list_themes
    ;;
*)
    usage
    ;;
esac
