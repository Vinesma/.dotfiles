#!/bin/bash

# Opens newsboat and updates unread counts after exiting out so that other scripts can use the info, syncing is also supported.
# Dependencies
# - newsboat

folder="$HOME/.dotfiles/scripts/newsboat"
sync_folder="$HOME/Sync"
last_read_saved=$(cat "$folder/archive_last_read.tmp")
last_read_time=$(stat -c %Y "$sync_folder/.newsboat_archive")

if [[ -e "$sync_folder/.newsboat_archive" ]] && [[ "$last_read_saved" != "$last_read_time" ]]; then
    newsboat -q -I "$sync_folder/.newsboat_archive"
fi

newsboat -q

newsboat -x print-unread | cut -d' ' -f 1 > "$folder/unread_count.tmp"

if [[ -e "$sync_folder" ]]; then
    newsboat -q -E "$sync_folder/.newsboat_archive"
    stat -c %Y "$sync_folder/.newsboat_archive" > "$folder/archive_last_read.tmp"
fi
