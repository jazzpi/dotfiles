#!/bin/bash

prev_outputs="[]"
(
    echo initial # Trigger initial update
    i3-msg -t subscribe -m '[ "output" ]'
) | while IFS='' read line; do
    now_outputs=`i3-msg -t get_outputs | jq -c 'map(select(.active == true) | .name)'`
    new=`jq -c -n --argjson prev "$prev_outputs" --argjson now "$now_outputs" '$now - $prev'`
    old=`jq -c -n --argjson prev "$prev_outputs" --argjson now "$now_outputs" '$prev - $now'`
    for output in `echo "$old" | jq -r '.[]'`; do
        echo "Removing $output"
        eww close "bar_$output"
    done
    for output in `echo "$new" | jq -r '.[]'`; do
        echo "Adding $output"
        eww open bar --id "bar_$output" --arg "monitor=$output"
    done
    prev_outputs="$now_outputs"
    eww reload
done
