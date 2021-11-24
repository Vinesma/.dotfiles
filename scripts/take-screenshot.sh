#!/usr/bin/env bash
#
# Script meant to run via hotkey, takes a screenshot of the whole screen and sends a notification
# Dependencies:
# - scrot

filename_format='%Y-%m-%d_$wx$h.png'
mv_command='mv $f ~/Pictures/'
notify_command='notify-send -i /usr/share/icons/Papirus-Dark/32x32/devices/camera-photo.svg "SCROT" "Screenshot: $f taken"'
run_command="$mv_command; $notify_command"

# Check arguments
# If any, take screenshot out of a selection of the screen
# If none, take screenshot of the entire screen
if [ "$#" -gt 0 ]; then
    scrot -z -s -l style=dash,width=1 "$filename_format" -e "$run_command"
else
    scrot -z "$filename_format" -e "$run_command"
fi
