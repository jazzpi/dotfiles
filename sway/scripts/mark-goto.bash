#!/bin/bash

marks=$(i3-msg -t get_marks | sed -e 's/\[//;s/"//g;s/,/ /g;s/\]//')
i3-input -F '[con_mark="%s"] focus' -P "Jump to [$marks]: " -l1
