#!/bin/bash

# //Description//
# Features:
# -
# Dependencies:
# -

music_folder="$HOME/Music"

add-album() {
    echo "$1" | mpc add
    mpc shuffle
    mpc play
}

show-menu() {
    local all_albums
    all_albums=$(ls "$music_folder")
    
    album=$(echo -e " Exit\n Clear Queue\n$all_albums" | \
    rofi -dmenu -no-custom -i -p ' Play' -lines 10)

    case "$album" in
        *Exit) exit ;;
        *Clear\ Queue) mpc clear ;;
        *) add-album "$album" ;;
    esac
}

show-menu
