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

show-all-music() {
    local track
    track=$(mpc listall | rofi -dmenu -no-custom -i -p ' Play one' -lines 15)
    echo "$track" | mpc add
    mpc play
}

show-menu() {
    local all_albums
    local album
    all_albums=$(ls "$music_folder")
    
    while true; do
        album=$(echo -e " Exit\n Clear Queue\n All Tracks\n$all_albums" | \
        rofi -dmenu -no-custom -i -p ' Play' -lines 10)

        case "$album" in
            *Exit) exit ;;
            *Clear\ Queue) clear-queue ;;
            *All\ Tracks) show-all-music ;;
            *) add-album "$album" ;;
        esac
    done
}

show-menu
