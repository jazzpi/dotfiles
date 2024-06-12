#!/bin/bash

if [ $# -lt 1 ]; then
    echo >&2 "Usage: $0 SCRIPTNAME [ARGS...]"
    exit 1
fi

case "$XDG_CURRENT_DESKTOP" in
i3)
    desktop=i3
    ;;
*)
    echo >&2 "Unsupported desktop '$XDG_CURRENT_DESKTOP'"
    exit 1
    ;;
esac

script_dir=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")

script="$1"
shift 1

exec "$script_dir/$desktop/$script.sh" $@
