#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

newsboat_path="/usr/bin/newsboat"
notify_send_path="/usr/bin/notify-send"
icon="/usr/share/icons/Papirus/32x32/apps/akregator.svg"

"$newsboat_path" -x reload

unread=$("$newsboat_path" -x print-unread)

"$notify_send_path" -i "$icon" "NEWSBOAT" "$num_unread"
