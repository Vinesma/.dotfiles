#!/bin/bash

video-info() {
        local video=$(youtube-dl --get-title --get-duration --get-thumbnail $1)
        local title=$(echo "$video" | head -n 1)
        local thumbnail=$(echo "$video" | head -n 2 | tail -n 1)
        local duration=$(echo "$video" | tail -n 1)
        feh "$thumbnail" -F --title "$title" --info "echo \"LENGTH: $duration\""
}

if [[ "$1" == *youtube.com* ]]; then
    echo
    echo "This appears to be a youtube link, what to do?"
    echo -e "1. Watch it\n2. Download it\n3. Open in browser\n4. Show video info\n5. Exit"
    read option
    case $option in
        1) mpv --fullscreen=no --profile=youtube720p $1;;
        2) youtube-dl -f 22/18 $1;;
        3) firefox $1 &;;
	4) video-info $1;;
        *) echo;;
    esac
elif [[ "$1" == @(*.jpg|*.jpeg|*.png) ]]; then
    feh -F "$1"
elif [[ "$1" == @(*.mp4) ]]; then
    mpv --loop "$1"
else
    firefox "$1" &
fi

clear
