#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

current_status=$(mpc)

message="$current_status"

$notify_send_dir "MPD" "$message"



