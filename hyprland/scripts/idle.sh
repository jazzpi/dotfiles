#!/bin/sh

swayidle \
    timeout 300 'swaylock --fade-in 5 --grace 5' \
    timeout 360 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on' \
    before-sleep 'swaylock'
