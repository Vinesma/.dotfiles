#!/usr/bin/env bash
#
# POLYBAR SCRIPT

ICON=

if bluetoothctl show | grep -q "Powered: yes"; then
    printf "%s" "$ICON"
else
    printf ""
fi