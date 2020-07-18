#!/bin/bash
#
# Script meant to run via hotkey, takes a screenshot of the whole screen and sends a notification
# Dependencies:
# - scrot

filename_format='%Y-%m-%d_$wx$h.png'
mv_command='mv $f ~/Pictures/'
notify_command='notify-send -i /usr/share/icons/Papirus-Dark/32x32/devices/camera-photo.svg "SCROT" "Screenshot: $f taken"'
run_command="$mv_command; $notify_command"

scrot -z "$filename_format" -e "$run_command"
