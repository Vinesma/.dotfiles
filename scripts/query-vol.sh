#!/bin/bash
#
# Shows mpd volume information in a quick notification, if an argument is passed, change the volume
#

icon="/usr/share/icons/Adwaita/32x32/devices/audio-speakers-symbolic.symbolic.png"
notify_time="800"

[[ "$#" -gt 0 ]] && mpc volume "$1"

current_vol=$(mpc | grep volume | cut -d' ' -f2)

[[ "$current_vol" ]] && message="VOL: $current_vol" || message="VOL: 100%"

notify-send -i "$icon" -t "$notify_time" "MPD" "$message"
