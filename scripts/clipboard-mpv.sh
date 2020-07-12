#!/bin/bash
#
# Script meant to be run by a qtile keybind, opens a rofi menu for watching videos in mpv.
#

mpv_dir="/usr/bin/mpv"
xclip_dir="/usr/bin/xclip"
youtubedl_dir="/usr/bin/youtube-dl"
rofi_dir="/usr/bin/rofi"
mpv_dir="/usr/bin/mpv"
link="$($xclip_dir -o)"

get-video-info() {
    notify-send -t 1800 "MPV" "[youtube-dl] loading video information..."
    video_info="$($youtubedl_dir -F $link)"

    format=$(echo "$video_info" | \
    awk '{print $1 "  " $3}' | \
    sed '1,3d' | \
    sort | \
    "$rofi_dir" -dmenu | \
    cut -d' ' -f 1)

    notify-send -t 1800 "MPV" "starting playback..."
    "$mpv_dir" --ytdl-format="$format" "$link" &
}

send-error() {
    notify-send -t 1800 "MPV" "$1"
    exit 1
}

case "$link" in
    *youtube.com*|*youtu.be*|*twitch.tv*) get-video-info ;;
    *) send-error "unsupported link, exiting" ;;
esac
