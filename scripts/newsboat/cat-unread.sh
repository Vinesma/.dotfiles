#!/usr/bin/env bash

folder="$HOME/.dotfiles/scripts/newsboat"
upper_limit=500
lower_limit=50

if [[ -e "$folder/unread_count.tmp" ]]; then
    unread_count=$(< "$folder/unread_count.tmp")

    if [ "$unread_count" -gt "$upper_limit" ]; then
        echo "$upper_limit+"
    elif [ "$unread_count" -lt "$lower_limit" ]; then
        echo ""
    else
        echo "$unread_count"
    fi
else
    echo ""
fi
