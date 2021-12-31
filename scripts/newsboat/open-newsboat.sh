#!/usr/bin/env bash

# Opens newsboat and updates unread counts after exiting out so that other scripts can use the info, syncing is also supported.
# Dependencies
# - newsboat

NEWSBOAT_SCRIPTS_DIR="$HOME/.dotfiles/scripts/newsboat"
LOCKFILE=/tmp/newsboat.lock
ICON_ERROR="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

if flock -n $LOCKFILE newsboat -q; then
    if unread_count=$(flock -n $LOCKFILE newsboat -x print-unread); then
        printf "%s" "$unread_count" | cut -d ' ' -f 1 > "$NEWSBOAT_SCRIPTS_DIR/unread_count.tmp"
    fi
else
    notify-send -i "$ICON_ERROR" "NEWSBOAT" "Newsboat is already running, either wait for it to complete or exit the other instance."
fi
