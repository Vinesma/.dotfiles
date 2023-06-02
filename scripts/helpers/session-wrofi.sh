#!/usr/bin/env bash
#
# Runs Rofi or Wofi depending on user's session type

rofi_theme="$HOME/.cache/wal/colors-rofi-launcher"

rofi-cmd() {
    rofi \
    -dmenu \
    -only-match \
    -i \
    -theme "$rofi_theme" \
    -no-show-icons \
    "$@"
}

wofi-cmd() {
    wofi \
    --dmenu \
    --cache-file /dev/null \
    -i \
    "$@"
}

wrofi-switch() {
    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        rofi-cmd "$@"
    else
        wofi-cmd "$@"
    fi
}