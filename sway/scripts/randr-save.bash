#!/bin/bash

# What directory is this script in?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

i3-input -F "exec '$DIR/randr.bash' save '%s'" -P 'Save configuration as: '
