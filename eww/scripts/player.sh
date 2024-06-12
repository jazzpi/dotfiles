#!/bin/bash

PLAYERS=spotify

playing=""
metadata=""

(
    playerctl -p "$PLAYERS" -F metadata --format '{{status}} ##### {{mpris:artUrl}} ##### {{artist}} ##### {{title}}'
) | while IFS='' read line; do
    if [ -z "$line" ]; then
        echo "{\"status\":\"stopped\",\"art\":\"\",\"artist\":\"\",\"title\":\"\"}"
    fi
    separated=$(echo "$line" | awk -F ' ##### ' 'BEGIN{OFS="\n";} {$1=$1}1')
    IFS=$'\n' read -rd '' status art artist title <<<"$separated"
    echo "{\"status\":\"$status\",\"art\":\"$art\",\"artist\":\"$artist\",\"title\":\"$title\"}"
done
