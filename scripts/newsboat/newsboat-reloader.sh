#!/usr/bin/env bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

NEWSBOAT="/usr/bin/newsboat"
NEWSBOAT_SCRIPTS_DIR="$HOME/.dotfiles/scripts/newsboat"
LOCKFILE=/tmp/newsboat.lock
CUT="/usr/bin/cut"
FLOCK="/usr/bin/flock"
NOTIFY_SEND="/usr/bin/notify-send"
ICON_RSS="/usr/share/icons/Papirus/32x32/apps/akregator.svg"

$FLOCK -n $LOCKFILE $NEWSBOAT -x reload || exit 1

if unread_count=$($FLOCK -n $LOCKFILE $NEWSBOAT -x print-unread); then
    "$NOTIFY_SEND" -i "$ICON_RSS" "NEWSBOAT" "$unread_count"

    printf "%s" "$unread_count" | "$CUT" -d ' ' -f 1 > "$NEWSBOAT_SCRIPTS_DIR/unread_count.tmp"
fi
