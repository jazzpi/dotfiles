#!/bin/sh

swayidle \
    timeout 300 'swaylock --fade-in 5 --grace 5' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep 'swaylock'
