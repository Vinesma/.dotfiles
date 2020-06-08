#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

current_status=$(cmus-remote -Q | grep status | cut -d' ' -f2)
current_track=$(cmus-remote -Q | grep title | cut -d' ' -f3-)
current_artist=$(cmus-remote -Q | grep artist | cut -d' ' -f3-)
current_album=$(cmus-remote -Q | grep album | cut -d' ' -f3-)
current_vol=$(cmus-remote -Q | grep vol_left | cut -d' ' -f3)

message="$current_status\n$current_artist - $current_track\n$current_album\nVOL: $current_vol"

$notify_send_dir "CMUS" "$message"



