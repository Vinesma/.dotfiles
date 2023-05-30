#!/usr/bin/env bash

notify_send_dir="/usr/bin/notify-send"
notify_time="3000"

state=$(nmcli n connectivity check)

if ping_status=$(ping -c 10 archlinux.org); then
    packets=$(echo "$ping_status" | grep "packet loss" | cut -d',' -f3)
    icon="/usr/share/icons/Papirus/32x32/status/online.svg"
    message="STATE: $state\nPACKETS:$packets"
else
    icon="/usr/share/icons/Papirus/32x32/status/offline.svg"
    message="STATE: $state\nPING FAILED"
fi

$notify_send_dir -i "$icon" -t "$notify_time" "CONNECTION STATUS" "$message"
