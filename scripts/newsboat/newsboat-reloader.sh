#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

newsboat_path="/usr/bin/newsboat"
notify_send_path="/usr/bin/notify-send"
cut_path="/usr/bin/cut"
cat_path="/usr/bin/cat"
stat_path="/usr/bin/stat"
icon="/usr/share/icons/Papirus/32x32/apps/akregator.svg"
folder="$HOME/.dotfiles/scripts/newsboat"
sync_folder="$HOME/Sync"

"$newsboat_path" -x reload

last_read_saved=$("$cat_path" "$folder/archive_last_read.tmp")
last_read_time=$("$stat_path" -c %Y "$sync_folder/.newsboat_archive")

if [[ -e "$sync_folder/.newsboat_archive" ]] && [[ "$last_read_saved" != "$last_read_time" ]]; then
    "$newsboat_path" -q -I "$sync_folder/.newsboat_archive"
fi

if [[ -e "$sync_folder" ]]; then
    "$newsboat_path" -q -E "$sync_folder/.newsboat_archive"
    "$stat_path" -c %Y "$sync_folder/.newsboat_archive" > "$folder/archive_last_read.tmp"
fi

if unread=$("$newsboat_path" -x print-unread); then
    "$notify_send_path" -i "$icon" "NEWSBOAT" "$unread"
    echo "$unread" | "$cut_path" -d ' ' -f 1 > "$folder/unread_count.tmp"
fi
