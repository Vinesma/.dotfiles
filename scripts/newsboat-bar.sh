#!/bin/bash
# This script can be used to reload newsboat but that means the bar can't be updated as often
# Just comment out the next 3 lines if you don't want to reload

# export DISPLAY=:0
# export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'
# newsboat -x reload

if unread_articles=$(newsboat -x print-unread | cut -d' ' -f 1) && [[ "$unread_articles" -gt 50 ]]; then
    if [[ "$unread_articles" -gt 500 ]]; then
        echo "500+"
    else
        echo "$unread_articles"
    fi
else
    echo ""
fi
