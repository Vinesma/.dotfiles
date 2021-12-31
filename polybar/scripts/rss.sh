#!/usr/bin/env bash
#
# POLYBAR SCRIPT

NEWSBOAT_UNREAD_FILE=$HOME/.dotfiles/scripts/newsboat/unread_count.tmp
[ ! -f "$NEWSBOAT_UNREAD_FILE" ] && { printf ""; exit 0; }

UNREAD=$(< "$NEWSBOAT_UNREAD_FILE")
UPPER_LIMIT=500
LOWER_LIMIT=50
ICON=

if (( UNREAD > UPPER_LIMIT )); then
    printf "%s%s\n" $ICON "$UPPER_LIMIT+"
elif (( UNREAD < LOWER_LIMIT )); then
    echo ""
else
    printf "%s%s\n" $ICON "$UNREAD"
fi