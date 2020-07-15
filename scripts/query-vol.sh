#!/bin/bash
#
# Shows mpd volume information in a quick notification
#

notify_send_dir="/usr/bin/notify-send"
icon="/usr/share/icons/Papirus-Dark/32x32/devices/audio-speakers.svg"

current_vol=$(mpc | grep volume | cut -d' ' -f2)

[[ $current_vol ]] && message="VOL: $current_vol" || message="VOL: 100%"

$notify_send_dir -i "$icon" -t 800 "MPD" "$message"



