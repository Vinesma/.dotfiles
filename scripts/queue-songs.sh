#!/bin/bash

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"
icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

if [[ "$#" -gt 0 ]]; then
    mpc crop
    mpc search genre "$1" | mpc add
    mpc shuffle
    mpc repeat on
    mpc play

    notify-send -i "$icon" "MPD" "Playing all $1 tracks!"
else
    notify-send -i "$icon_error" "[queue-songs]" "Invalid number of arguments"
fi
