#!/usr/bin/env bash
#
# POLYBAR SCRIPT

ICON=

if bluetoothctl show | grep -q "Powered: yes"; then
    printf "%s\n" "$ICON"
else
    echo ""
fi