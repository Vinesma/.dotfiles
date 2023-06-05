#!/usr/bin/env bash
#
# Control the use of the external monitor

EXTERNAL_MONITOR_NAME=$1

[[ -z $EXTERNAL_MONITOR_NAME ]] && exit

if hyprctl monitors | grep "$EXTERNAL_MONITOR_NAME"; then
    hyprctl --batch "keyword monitor $EXTERNAL_MONITOR_NAME,disabled;"
else
    monitor_command=$(\
        grep -m 1 \
        monitor="$EXTERNAL_MONITOR_NAME" \
        "$HOME/.config/hypr/hyprland.conf" | cut -d'=' -f2)

    hyprctl --batch "keyword monitor $monitor_command;"
fi
