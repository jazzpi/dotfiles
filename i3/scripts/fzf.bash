#!/bin/bash

if [ $# -eq 0 ]; then
    # Launch an XTerm running fzf. We need to capture its output as well, so we
    # tee it to a FIFO.
    inpipe=$(mktemp -u)
    mkfifo -m 600 "$inpipe"
    outpipe=$(mktemp -u)
    mkfifo -m 600 "$outpipe"

    xterm -fa "DejaVu Sans Mono" -fs 9 -bg black -fg white -class fzf -e "$HOME/.config/i3/scripts/fzf.bash '$inpipe' '$outpipe'" &
    cat /dev/stdin >"$inpipe"
    cat "$outpipe"

    rm "$inpipe"
    rm "$outpipe"
elif [ $# -eq 2 ]; then
    cat "$1" | fzf --reverse | tee "$2"
else
    >&2 echo "Usage: ${BASH_SOURCE[0]} [inpipe outpipe]"
fi
