#!/bin/bash

# Creates a popup window for the user to select an album, then immediately starts playing.
# Dependencies:
# - mpd, mpc, rofi

music_folder="$HOME/Music"
icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"

clear-queue() {
    mpc clear
    notify-send -i "$icon" "MPD" "Queue cleared!"
}

add-album() {
    echo "$1" | mpc add
    mpc shuffle
    mpc play
    notify-send -i "$icon" "MPD" "$1 added to queue!"
}

show-menu() {
    local all_albums
    all_albums=$(ls "$music_folder")
    
    album=$(echo -e " Exit\n Clear Queue\n$all_albums" | \
    rofi -dmenu -no-custom -i -p ' Play' -lines 10)

    case "$album" in
        *Exit) exit ;;
        *Clear\ Queue) clear-queue ;;
        *) add-album "$album" ;;
    esac
}

show-menu
