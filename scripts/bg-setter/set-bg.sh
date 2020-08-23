#!/bin/bash

# Sets wallpapers.
# Dependencies:
# feh, pywal

wal -n -e -i "$@"
feh --bg-scale "$(< "${HOME}/.cache/wal/wal")"
qtile-cmd -o cmd -f restart >/dev/null 2>&1
kill $(pgrep dunst) && notify-send "DUNST" "New dunst theme set"
pywalfox update

notify-send "set-bg" "New background set"
