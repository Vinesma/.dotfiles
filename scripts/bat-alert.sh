#!/usr/bin/env bash
#
# Send alert if battery gets below threshold
#

notify_send_path="/usr/bin/notify-send"
warn_icon="/usr/share/icons/Papirus/32x32/status/dialog-warning.svg"

if [ "$#" -eq 2 ]; then
    if current_battery=$(< /sys/class/power_supply/"$2"/capacity); then
        if [ "$current_battery" -le "$1" ]; then
            "$notify_send_path" -u critical -i "$warn_icon" "Current battery levels are low!" "$2: $current_battery%"
        fi
    else
        echo "Couldn't find battery: $2"
    fi
else
    echo "$0: Send alert if battery gets below threshold"
fi
