#!/usr/bin/env bash
#

if ! update_count=$(checkupdates 2> /dev/null | wc -l); then
    update_count=0
fi

if [ "$update_count" -gt 0 ]; then
    printf "%s" "$update_count"
else
    printf "%s" ""
fi
