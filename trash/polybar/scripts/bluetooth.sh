#!/usr/bin/env bash
#
# POLYBAR SCRIPT

command -v bluetoothctl &> /dev/null || exit

ICON=

if bluetoothctl show | grep -q "Powered: yes"; then
    printf "%s\n" "$ICON"
else
    echo ""
fi
