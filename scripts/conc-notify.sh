#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

state=$(nmcli n connectivity check)

if packet_status=$(ping -c 10 google.com | grep "packet loss" | cut -d',' -f3); then
    message="STATE: $state\nPACKETS:$packet_status"
else
    message="STATE: $state\nPING FAILED"
fi

$notify_send_dir "CONNECTION STATUS" "$message"
