#!/usr/bin/env bash

# Sets wallpapers.
# Dependencies:
# feh, pywal

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_image="/usr/share/icons/Papirus/32x32/apps/multimedia-photo-viewer.svg"
jellyfin_css_path="$HOME/.cache/wal/colors-jellyfin.css"
notify_time=2000
session_type=$XDG_SESSION_TYPE

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

reset-xava() {
    local xava_name
    xava_name=xava-x86_64.AppImage
    if command -v "$xava_name" && killall -q "$xava_name"; then
        xava-x86_64.AppImage -p ~/.cache/wal/xava-config &
    fi
}

if wal -n -e -i "$@"; then
    if [ "$session_type" != "wayland" ]; then
        printf "%s\n" "Session type is Xorg."
        feh --bg-scale "$(< "${HOME}/.cache/wal/wal")"

        { pgrep qtile && qtile cmd-obj -o cmd -f restart; } &> /dev/null
        { pgrep openbox && openbox --reconfigure; } &> /dev/null

        reset-polybar
    fi

    patch-rofi
    pkill dunst
    /usr/bin/pywalfox update

    notify-send -i "$icon_image" "set-bg" "New background and theme set."
    reset-xava
    update-jellyfin
else
    send-error "pywal returned an error"
fi
