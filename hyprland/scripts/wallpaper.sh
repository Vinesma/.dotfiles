#!/usr/bin/env bash
#
# Set the wallpaper in Wayland

CURRENT_WALLPAPER_PATH=$(< "$HOME/.cache/wal/wal")
WALLPAPER_PATH=${1:-$CURRENT_WALLPAPER_PATH}
WALLPAPER_SETTER=swaybg

killall -q "$WALLPAPER_SETTER"

"$WALLPAPER_SETTER" -i "$WALLPAPER_PATH" & disown
