#!/bin/bash

I3_THEME_DIR="$HOME/.config/i3/themes"
I3_LOCAL_DIR="$HOME/.config/i3/.local"

function usage {
    >&2 echo "Usage: ${BASH_SOURCE[0]} (list|reload) | load [THEME] | install_only THEME | getres NAME DEFAULT"
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
    rm -f "$I3_LOCAL_DIR/current-theme"
    ln -s -f "$I3_THEME_DIR/$1" "$I3_LOCAL_DIR/current-theme"
}

function reload_theme {
    xrdb -override "$I3_LOCAL_DIR/current-theme/resources"
    local img=$(sed -e '/i3wm\.background_image/s/[^:]*: //p' -n ~/.config/i3/.local/current-theme/resources)
    &>/dev/null pgrep i3 && i3-msg restart
    feh --bg-scale ${img/#\~/$HOME}
}

function list_themes {
    [ -d "$I3_THEME_DIR" ] && ls "$I3_THEME_DIR" | paste -sd " " -
}

function get_res {
    local line=$(grep -F "$1" ~/.config/i3/.local/current-theme/resources)
    if [ -n "$line" ]; then
        echo ${line##[^:]* }
    else
        echo "$2"
    fi
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
"getres")
    if [ "$#" -ne 3 ]; then
        usage
    fi
    get_res "$2" "$3"
    ;;
*)
    usage
    ;;
esac
