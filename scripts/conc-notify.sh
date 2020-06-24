#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

state=$(nmcli n connectivity check)
packet_status=$(ping -c 10 google.com | grep "packet loss" | cut -d',' -f3)

[[ $packet_status ]] && message="STATE: $state\nPACKETS:$packet_status" || message="STATE: $state\nPING FAILED"

$notify_send_dir "CONNECTION STATUS" "$message"
