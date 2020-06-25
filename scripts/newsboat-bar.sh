#!/bin/sh

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

newsboat_path="/usr/bin/newsboat"

newsboat -x reload

unread_articles=$(newsboat -x print-unread | cut -d' ' -f 1)

echo "[RSS] #$unread_articles"
