#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

current_vol=$(mpc | grep volume | cut -d' ' -f2)

[[ $current_vol ]] && message="VOL: $current_vol" || message="VOL: 100%"

$notify_send_dir -t 800 "MPD" "$message"



