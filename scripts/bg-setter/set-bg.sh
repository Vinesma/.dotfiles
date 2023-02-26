#!/usr/bin/env bash

# Sets wallpapers.
# Dependencies:
# feh, pywal

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_image="/usr/share/icons/Papirus/32x32/apps/multimedia-photo-viewer.svg"
jellyfin_css_path="$HOME/.cache/wal/colors-jellyfin.css"
notify_time=2000

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "set-bg" "$1"
}

# Quick and dirty patch to the rofi result template since it looks like upstream will take thousands of years to update.
patch-rofi() {
    sed -i -e '$a\\nelement-text {\n    background-color: inherit;\n    text-color: inherit;\n}' ~/.cache/wal/colors-rofi-dark.rasi
}

# POST request to update server side CSS
# Uses env variables, if unset does nothing
update-jellyfin() {
    if [[ -n "$JF_SERVER_URL" && -n "$JF_API_KEY" ]]; then
        local rawCSS
        rawCSS=$(< "$jellyfin_css_path")
        curl \
        "$JF_SERVER_URL/System/Configuration/branding?api_key=$JF_API_KEY" \
        -X POST \
        -H 'Content-Type: application/json' \
        --data-raw "{\"LoginDisclaimer\":\"\",\"CustomCss\":\"${rawCSS}\",\"SplashscreenEnabled\":false}" && \
        notify-send "set-bg" "Jellyfin branding updated."
    fi
}

# Reset polybar if in use, otherwise do nothing
reset-polybar() {
    if killall -q polybar; then
        # shellcheck source=/dev/null
        . "$HOME/.dotfiles/polybar/launch.sh" &
    fi
}

if wal -n -e -i "$@"; then
    feh --bg-scale "$(< "${HOME}/.cache/wal/wal")"
    patch-rofi

    { pgrep qtile && qtile cmd-obj -o cmd -f restart; } &> /dev/null
    { pgrep openbox && openbox --reconfigure; } &> /dev/null

    pkill dunst
    "$HOME"/.local/bin/pywalfox update
    reset-polybar

    notify-send -i "$icon_image" "set-bg" "New background and theme set."
    update-jellyfin
else
    send-error "pywal returned an error"
fi
