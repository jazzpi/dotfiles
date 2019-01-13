#!/bin/bash

CFG_DIR="$HOME/.config/i3/.local/randr_cfgs"

function save_cfg {
    if [ -z "$1" ]; then
        usage
    fi

    mkdir -p "$CFG_DIR"

    local sed_pattern='^[^+]*+' # Beginning " n: +"
    sed_pattern+='\([^ ]*\) '   # Output name (plus * for primary output)
    sed_pattern+='\([[:digit:]]*\)/\([[:digit:]]*\)x'  # width (PIXELxMM)
    sed_pattern+='\([[:digit:]]*\)/\([[:digit:]]*\)+'  # height (PIXELxMM)
    sed_pattern+='\([[:digit:]]*\)+\([[:digit:]]*\).*' # offset (horiz+vert)
    local sed_replacement='\1 --mode \2x\4 --fbmm \3x\5 --pos \6x\7'
    local sed_cmd="s=$sed_pattern=$sed_replacement="

    ## Explanation of the following command (line-by-line)
    # Terse output
    # Skip the "Monitors: n" line
    # Magic happens here (see $sed_pattern above)
    # Replace "VGA-1*" with "VGA-1 --primary"
    # Prepend each output with "--output "
    # Merge it all into one line
    # Make it an xrandr command
    # Save it all in a file
    xrandr --listmonitors | \
        tail -n +2 | \
        sed "$sed_cmd" | \
        sed -e 's/^\*\([^ ]*\) /\1 --primary /' | \
        awk '{print "--output "$0}' | \
        tr '\n' ' ' | \
        awk '{print "xrandr "$0}' \
        > "$CFG_DIR/$1.cfg"
}

function restore_cfg {
    if [ -z "$1" ]; then
        usage
    fi

    if ! [ -f "$CFG_DIR/$1.cfg" ]; then
        >&2 echo "Config $1 does not exist"
        exit 1
    fi

    . "$CFG_DIR/$1.cfg"
}

function list_cfgs {
    [ -d "$CFG_DIR" ] && ls "$CFG_DIR" | sed -e 's/\.cfg$//' | paste -sd " " -
}

function usage {
    >&2 echo "usage: $0 list | save NAME | restore NAME"
}

case $1 in
    save)
        save_cfg $2
        ;;
    restore)
        restore_cfg $2
        ;;
    list)
        list_cfgs
        ;;
    *)
        usage
        ;;
esac
