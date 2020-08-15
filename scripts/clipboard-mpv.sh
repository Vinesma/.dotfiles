#!/bin/bash
#
# Script meant to be run by a qtile keybind, opens a rofi menu for watching videos in mpv.
# Features:
# - VIDEO: Choose video format and watch straight from the rofi menu after a single keypress
# Dependencies:
# mpv, xclip, youtube-dl, rofi

notify_time=2000

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_youtube_dl="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
icon_mpv="/usr/share/icons/Papirus/32x32/apps/mpv.svg"

# Check if script is passed and argument or not.
# If yes, use the argument
# If no, use the clipboard.
[[ "$#" -gt 0 ]] && link="$1" || link="$(xclip -o)"

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "MPV" "$1"
}

start-playback() {
    local timestamp

    timestamp="$(echo -e '0%\n25%\n50%\n75%\n90%' | rofi -dmenu -p 'Timestamp' -lines 5)"

    notify-send -i "$icon_mpv" -t "$notify_time" "MPV" "Starting playback..."
    if ! mpv --ytdl-format="$1" --start="$timestamp" "$link"; then
        send-error "Error during playback"
    fi
}

show-menu() {
    local format

    format=$(echo -e "$1\nExit" | \
    rofi -dmenu -only-match -p 'Video format' -lines 15 | \
    cut -d' ' -f 1)

    [[ "$format" != "Exit" ]] && start-playback "$format" || \
        send-error "Canceled by user" && exit 1
}

parse-video-info() {
    local choice

    choice=$(echo "$1" | \
    awk '{print $1 "  " $3 " - " $4}' | \
    sed '/\[.*\]/d' | \
    sed '1d' | \
    sort -n)

    show-menu "$choice"
}

get-video-info() {
    local video_info

    notify-send -i "$icon_youtube_dl" -t "$notify_time" "MPV" "[youtube-dl] Loading video information..."

    if video_info="$(youtube-dl -F --no-playlist "$link")"; then
        parse-video-info "$video_info"
    else
        send-error '[youtube-dl] Error while fetching video info' && exit 1
    fi
}

case "$link" in
    *youtube.com*|*youtu.be*|*twitch.tv*) get-video-info ;;
    *) send-error "Unsupported link, exiting" && exit 1 ;;
esac
