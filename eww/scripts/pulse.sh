#!/bin/bash

usage() {
    echo >&2 "Usage: pulse.sh monitor|toggle|change"
    exit 1
}

monitor() {
    (
        echo initial
        pactl subscribe
    ) | while IFS='' read line; do
        if [[ ! ("$line" == "initial" || "$line" =~ "Event 'change' on sink ") ]]; then
            continue
        fi
        mute=$(pactl get-sink-mute @DEFAULT_SINK@ | sed -E -n -e 's/Mute: ([a-z]+)/\1/p')
        vol=$(pactl get-sink-volume @DEFAULT_SINK@ | sed -E -n -e 's/.* ([0-9]+)%.*/\1/p')
        if [ "$mute" == "yes" ]; then
            icon=$'\uf6a9'
        elif (($vol == 0)); then
            icon=$'\uf026'
        elif (($vol < 55)); then
            icon=$'\uf027'
        else
            icon=$'\uf028'
        fi
        echo "{\"muted\":\"$mute\",\"volume\":$vol,\"icon\":\"$icon\"}"
    done
}

toggle() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

change() {
    case $1 in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    *)
        change_usage
        ;;
    esac
}

change_usage() {
    echo >&2 "Usage: pulse.sh change up|down"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

case $1 in
monitor)
    monitor
    ;;
toggle)
    toggle
    ;;
change)
    if [ $# -ne 2 ]; then
        change_usage
    fi
    change $2
    ;;
*)
    usage
    ;;
esac
