#!/bin/bash
#
# Queries music status if steam is running in the background (presumably a game is playing in fullscreen)
#

notify_send_dir="/usr/bin/notify-send"
pgrep_dir="/usr/bin/pgrep"
icon="/usr/share/icons/Papirus-Dark/32x32/apps/org.processing.processingide.svg"

if "$pgrep_dir" steam > /dev/null; then
    song_title=$(mpc current -f "%title%")
    song_artist=$(mpc current -f "%artist%")
    title="Now Playing"
    message="$song_title\n$song_artist"

    "$notify_send_dir" -i "$icon" "$title" "$message"
fi
