#!/usr/bin/env bash

# Opens newsboat and updates unread counts after exiting out so that other scripts can use the info, syncing is also supported.
# Dependencies
# - newsboat

folder="$HOME/.dotfiles/scripts/newsboat"
sync_folder="$HOME/Sync"
last_read_saved=$(< "$folder/archive_last_read.tmp")
last_read_time=$(stat -c %Y "$sync_folder/.newsboat_archive")
icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

# This check prevents newsboat from running on top of another instance and overwriting files
if [[ ! -e "/tmp/run-newsboat.tmp" ]]; then
    touch "/tmp/run-newsboat.tmp"

    if [[ -e "$sync_folder/.newsboat_archive" ]] && [[ "$last_read_saved" != "$last_read_time" ]]; then
        newsboat -q -I "$sync_folder/.newsboat_archive"
    fi

    newsboat -q

    newsboat -x print-unread | cut -d' ' -f 1 > "$folder/unread_count.tmp"

    if [[ -e "$sync_folder" ]]; then
        newsboat -q -E "$sync_folder/.newsboat_archive"
        stat -c %Y "$sync_folder/.newsboat_archive" > "$folder/archive_last_read.tmp"
    fi

    rm "/tmp/run-newsboat.tmp"
else
    notify-send -i "$icon_error" "NEWSBOAT" "Newsboat is already running, either wait for it to complete or exit the other instance."
fi
