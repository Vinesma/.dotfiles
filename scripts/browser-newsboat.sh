#!/bin/bash
#
# Script meant to be used by newsboat for handling links from youtube, images and other videos.
# Features:
# - YOUTUBE: Download, Watch or view thumbnail and duration of videos in the command line.
# - IMAGES: View images in the command line.
# - VIDEOS: Other than youtube, open in mpv in a loop. (Mainly, to emulate twitter video functionality)
# - OTHERS: Open in the browser.
# Dependencies:
# - feh, mpv, youtube-dl, firefox, rofi, clipboard-mpv.sh
#

clipboard_mpv_dir="$HOME/.dotfiles/scripts/clipboard-mpv.sh"

video-info() {
    local video
    local title
    local thumbnail
    local duration

    video=$(youtube-dl --get-title --get-duration --get-thumbnail "$1")
    title=$(echo "$video" | head -n 1)
    thumbnail=$(echo "$video" | sed -e '1d' -e '3d')
    duration=$(echo "$video" | tail -n 1)

    feh "$thumbnail" -F --title "$title" --info "echo \"LENGTH: $duration\""
}

if [[ "$1" == *youtube.com* ]]; then
    option=$(echo -e "1  Watch\n2  Download\n3  Open in browser\n4  Show video info\n5  Exit" | \
        rofi -dmenu -no-custom -p 'option' -format 'd' -mesg 'This is a youtube link, what to do?')
    case $option in
        1) "$clipboard_mpv_dir" "$1" ;;
        2) youtube-dl -f 22/18 "$1" ;;
        3) firefox "$1" & ;;
	4) video-info "$1" ;;
        *) echo ;;
    esac
elif [[ "$1" == @(*.jpg|*.jpeg|*.png) ]]; then
    feh -F "$1"
elif [[ "$1" == @(*.mp4) ]]; then
    mpv --loop "$1"
else
    firefox "$1" &
fi

clear
