#!/bin/bash
# Queries music status if steam is running in the background (presumably a game is playing in fullscreen)

notify_send_dir="/usr/bin/notify-send"
pgrep_dir="/usr/bin/pgrep"

current_status=$(mpc)

title=$(echo "$current_status" | head -n 1)
message=$(echo "$current_status" | tail -n +2)

$pgrep_dir steam > /dev/null && $notify_send_dir "$title" "$message"



