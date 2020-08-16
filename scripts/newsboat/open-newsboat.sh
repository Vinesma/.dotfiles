#!/bin/bash

# Opens newsboat and updates unread counts after exiting out so that other scripts can use the info
# Dependencies
# - newsboat

[[ -e "$sync_folder/.newsboat_archive" ]] && newsboat -q -I "$sync_folder/.newsboat_archive"

newsboat -q

folder="$HOME/.dotfiles/scripts/newsboat"
sync_folder="$HOME/Sync"

newsboat -x print-unread | cut -d' ' -f 1 > "$folder/unread_count.tmp"

[[ -e "$sync_folder" ]] && newsboat -q -E "$sync_folder/.newsboat_archive"
