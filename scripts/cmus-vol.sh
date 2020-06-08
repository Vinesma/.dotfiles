#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

current_vol=$(cmus-remote -Q | grep vol_left | cut -d' ' -f3)

message="VOL: $current_vol"

$notify_send_dir -t 800 "CMUS" "$message"



