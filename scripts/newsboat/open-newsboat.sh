#!/bin/bash

# Opens newsboat and updates unread counts after exiting out so that other scripts can use the info, syncing is also supported.
# Dependencies
# - newsboat

folder="$HOME/.dotfiles/scripts/newsboat"
sync_folder="$HOME/Sync"

[[ -e "$sync_folder/.newsboat_archive" ]] && newsboat -q -I "$sync_folder/.newsboat_archive"

newsboat -q

newsboat -x print-unread | cut -d' ' -f 1 > "$folder/unread_count.tmp"

[[ -e "$sync_folder" ]] && newsboat -q -E "$sync_folder/.newsboat_archive"
