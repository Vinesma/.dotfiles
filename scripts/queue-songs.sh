#!/bin/bash

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"
icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

if [[ "$#" -gt 0 ]]; then
    mpc crop
    mpc search "(genre contains \"$1\")" | mpc add
    mpc random on
    mpc repeat on

    notify-send -i "$icon" "MPD" "Queue set to '$1'"
else
    notify-send -i "$icon_error" "[queue-songs]" "Invalid number of arguments"
fi


