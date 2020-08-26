#!/bin/bash

# If we start Spotify right after starting i3, it will hang
sleep 1

if command -v spotify >/dev/null; then
    spotify
elif command -v flatpak >/dev/null; then
    flatpak run com.spotify.Client
else
    >&2 echo "No Spotify found!"
fi
