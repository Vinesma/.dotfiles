#!/bin/bash
#
# Queries music status if steam is running in the background (presumably a game is playing in fullscreen)
#

notify_send_dir="/usr/bin/notify-send"
pgrep_dir="/usr/bin/pgrep"
icon="/usr/share/icons/Papirus-Dark/32x32/apps/org.processing.processingide.svg"

# Uncomment these to use the old notification style
#current_status=$(mpc)
#title=$(echo "$current_status" | head -n 1)
#message=$(echo "$current_status" | sed '2,3d')

# Uncomment these to use the new notification style
current_status=$(mpc current)
title="Now Playing"
message="$current_status"

$pgrep_dir steam > /dev/null && $notify_send_dir -i "$icon" "$title" "$message"



