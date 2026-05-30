#!/usr/bin/env bash

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"
icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

clear-queue() {
    # IF a song is playing THEN don't interrupt : IF stopped THEN clear the whole queue.
    if [ "$(mpc | wc -l)" -ne 3 ]; then
        mpc clear
    else
        mpc crop
        mpc repeat off
    fi

    notify-send -i "$icon" "MPD" "Queue cleared!"
}

add-to-queue() {
    mpc crop
    mpc load "$1"
    mpc repeat on
    mpc play

    notify-send -i "$icon" "MPD" "Playing tracks from $1 playlist!"
}

if [ "$#" -gt 0 ]; then
    case "$1" in
        "clear-music") clear-queue ;;
        *) add-to-queue "$1";;
    esac
else
    notify-send -i "$icon_error" "[queue-songs]" "Invalid number of arguments"
fi
