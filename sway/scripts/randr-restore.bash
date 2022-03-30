#!/bin/bash

# What directory is this script in?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if ! configs=$("$DIR/randr.bash" list); then
    i3-nagbar -m 'No configurations exist!'
    exit 1
fi

i3-input -F "exec '$DIR/randr.bash' restore '%s'" -P "Restore from [$configs]:"
