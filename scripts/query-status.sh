#!/bin/bash
# Queries music status if steam is running in the background (presumably a game is playing in fullscreen)

notify_send_dir="/usr/bin/notify-send"
pgrep_dir="/usr/bin/pgrep"

# Uncomment these to use the old notification style
#current_status=$(mpc)
#title=$(echo "$current_status" | head -n 1)
#message=$(echo "$current_status" | tail -n +2)

# Uncomment these to use the new notification style
current_status=$(mpc current)
title="Now Playing"
message="$current_status"

$pgrep_dir steam > /dev/null && $notify_send_dir "$title" "$message"



