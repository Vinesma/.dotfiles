#!/usr/bin/env bash

# Sets wallpapers.
# Dependencies:
# feh, pywal

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_image="/usr/share/icons/Papirus/32x32/apps/multimedia-photo-viewer.svg"
notify_time=2000

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "set-bg" "$1"
}

patch-rofi() {
    #quick and dirty patch to the rofi result template since it looks like upstream will take thousands of years to update.
    sed -i -e '$a\\nelement-text {\n    background-color: inherit;\n    text-color: inherit;\n}' ~/.cache/wal/colors-rofi-dark.rasi
}

if wal -n -e -i "$@"; then
    #. ~/.dotfiles/polybar/launch.sh &
    feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" && patch-rofi
    qtile cmd-obj -o cmd -f restart >/dev/null 2>&1
    pkill dunst
    pywalfox update

    notify-send -i "$icon_image" "set-bg" "New background set"
else
    send-error "pywal returned an error"
fi
