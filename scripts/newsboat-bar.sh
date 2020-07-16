#!/bin/sh
# This script can be used to reload newsboat but that means the bar can't be updated as often
# Just comment out the next 3 lines if you don't want to reload

# export DISPLAY=:0
# export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'
# newsboat -x reload

unread_articles=$(newsboat -x print-unread | cut -d' ' -f 1)

[ "$unread_articles" ] && [ "$unread_articles" -gt 0 ] && echo "$unread_articles" || echo ""
