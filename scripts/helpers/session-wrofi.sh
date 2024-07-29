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

wrofi-switch() {
    rofi-cmd "$@"
}
