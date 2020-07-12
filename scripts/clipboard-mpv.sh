#!/bin/bash
#
# Script meant to be run by a qtile keybind, opens a rofi menu for watching videos in mpv.
# Features:
# - VIDEO: Choose video format and watch straight from the rofi menu after a single keypress
# Dependencies:
# mpv, xclip, youtube-dl, rofi

mpv_dir="/usr/bin/mpv"
xclip_dir="/usr/bin/xclip"
youtubedl_dir="/usr/bin/youtube-dl"
rofi_dir="/usr/bin/rofi"
link="$($xclip_dir -o)"

send-error() {
    notify-send -t 1800 "MPV" "$1"
}

start-playback() {
    timestamp="$(echo -e '0%\n25%\n50%\n75%\n90%' | $rofi_dir -dmenu -p 'Timestamp' -lines 5)"

    notify-send -t 1800 "MPV" "Starting playback..."
    "$mpv_dir" --ytdl-format="$1" --start="$timestamp" "$link" &
}

parse-video-info() {
    format=$(echo "$1" | \
    awk '{print $1 "  " $3}' | \
    sed '1,3d' | \
    sort | \
    "$rofi_dir" -dmenu -no-custom -p 'Video format' -lines 15 | \
    cut -d' ' -f 1)

    start-playback "$format"
}

get-video-info() {
    notify-send -t 1800 "MPV" "[youtube-dl] Loading video information..."
    video_info="$($youtubedl_dir -F $link)"

    [[ $? -eq 0 ]] && parse-video-info "$video_info" || \
        send-error '[youtube-dl] Error while fetching video info' && exit 1
}

case "$link" in
    *youtube.com*|*youtu.be*|*twitch.tv*) get-video-info ;;
    *) send-error "Unsupported link, exiting" && exit 1 ;;
esac
