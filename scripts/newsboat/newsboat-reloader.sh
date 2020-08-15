#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

newsboat_path="/usr/bin/newsboat"
notify_send_path="/usr/bin/notify-send"
cut_path="/usr/bin/cut"
icon="/usr/share/icons/Papirus/32x32/apps/akregator.svg"
folder="$HOME/.dotfiles/scripts/newsboat"

"$newsboat_path" -x reload

if unread=$("$newsboat_path" -x print-unread); then
    "$notify_send_path" -i "$icon" "NEWSBOAT" "$unread"
    echo "$unread" | "$cut_path" -d ' ' -f 1 > "$folder/unread_count.tmp"
fi
