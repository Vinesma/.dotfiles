#!/bin/bash

# Sets wallpapers.
# Dependencies:
# feh, pywal

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_image="/usr/share/icons/Papirus/32x32/apps/multimedia-photo-viewer.svg"

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "set-bg" "$1"
}

if wal -n -e -i "$@"; then
    . ~/.dotfiles/polybar/launch.sh &
    feh --bg-scale "$(< "${HOME}/.cache/wal/wal")"
    qtile-cmd -o cmd -f restart >/dev/null 2>&1
    pkill dunst
    pkill redshift-gtk
    redshift-gtk &

    notify-send -i "$icon_image" "set-bg" "New background set"
else
    send-error "pywal returned an error"
fi
