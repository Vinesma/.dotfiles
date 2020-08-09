#!/bin/bash

# Opens newsboat and updates unread counts after exiting out so that other scripts can use the info
# Dependencies
# - newsboat

newsboat -q

folder="$HOME/.dotfiles/scripts/newsboat"
unread=$(newsboat -x print-unread | cut -d' ' -f 1)

echo "$unread" > "$folder/unread_count"
