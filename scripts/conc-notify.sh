#!/bin/bash

notify_send_dir="/usr/bin/notify-send"

state=$(nmcli n connectivity check)
packet_status=$(ping -c 5 google.com | grep "packet loss" | cut -d',' -f3)

message="STATE: $state\nPACKETS:$packet_status"

$notify_send_dir "CONNECTION STATUS" "$message"
