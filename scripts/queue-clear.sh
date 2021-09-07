#!/usr/bin/env bash

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"

# IF a song is playing THEN don't interrupt : IF stopped THEN clear the whole queue.
if [[ $(mpc | wc -l) -ne 3 ]]; then
    mpc clear
else
    mpc crop
    mpc repeat off
fi

notify-send -i "$icon" "MPD" "Queue cleared!"


