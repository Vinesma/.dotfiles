#!/bin/bash
#
# Shows mpd volume information in a quick notification, if an argument is passed, change the volume
#

icon="/usr/share/icons/Papirus/32x32/devices/audio-speakers.svg"
notify_time="800"

[[ "$#" -gt 0 ]] && mpc volume "$1"

message=$(mpc volume)

notify-send -i "$icon" -t "$notify_time" "MPD" "$message"
