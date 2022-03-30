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

function gnome_terminal_theme {
    local i=0
    local profile
    for p in $(dconf list /org/gnome/terminal/legacy/profiles:/ | grep '/$'); do
        local name=$(dconf read /org/gnome/terminal/legacy/profiles:/${p}visible-name | sed -e "s/^'//;s/'\$//")
        if [ "$name" = "$1" ]; then
            profile="$p"
            break
        fi
        i=$(($i + 1))
    done
    local keystroke="Menu Up Up Up Right"
    for j in $(seq 2 $i); do
        keystroke="$keystroke Down"
    done
    xdotool search --class 'Gnome-terminal' | xargs -n1 -I{} sh -c "xwininfo -id {} | grep -q 'Map State: IsUnMapped' || (echo {}; xdotool windowactivate --sync {} key Menu $keystroke Return)"
}

function reload_theme {
    (
        echo "# Reloading resources..."
        echo "0"
        xrdb -override "$I3_LOCAL_DIR/current-theme/resources"
        echo "# Restarting i3..."
        echo "25"
        if pgrep i3 &>/dev/null; then
            # Wait for i3 to restart, otherwise Xorg gets very confused
            i3-msg restart
            until i3-msg -t get_version &>/dev/null; do
                sleep 0.1
            done
            sleep 0.5
        fi
        echo "# Reloading Emacs theme..."
        echo "50"
        nohup emacsclient -e "(load-theme '$(get_res 'emacs.theme'))" &>/dev/null &
        echo "# Reloading wallpaper..."
        echo "75"
        local img=$(get_res 'i3wm.background_image')
        nohup feh --bg-scale ${img/#\~/$HOME} &>/dev/null &
        # echo "# Reloading gnome-terminal theme..."
        # echo "80"
        # gnome_terminal_theme $(get_res 'gnome-terminal.theme')
        echo "100"
    ) | zenity --progress --title="Loading Theme..." --no-cancel --auto-close
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
