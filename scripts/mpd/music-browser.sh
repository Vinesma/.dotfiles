#!/usr/bin/env bash

# Creates a popup window for the user to select an album, then immediately starts playing.
# Dependencies:
# - mpd, mpc, rofi

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"
rofi_theme="$HOME/.cache/wal/colors-rofi-launcher"

queue_script_path="$HOME/.dotfiles/scripts/mpd/queue-music.sh"

add-album() {
    echo "$1" | mpc add
    mpc shuffle
    mpc play
    notify-send -i "$icon" "MPD" "$1 added to queue!"
}

show-all-music() {
    local track
    local title
    track=$(mpc listall | rofi -dmenu -only-match -i -p ' Play one' -lines 15)
    title=$(echo "$track" | sed -e 's/.*\///' -e 's/\.mp3//')

    echo "$track" | mpc add
    mpc play
    notify-send -i "$icon" "MPD" "$title added to queue!"
}

show-genres() {
    local genre
    genre=$(mpc list genre | rofi -dmenu -only-match -i -p 'Play all from' -lines 10)

    . "$queue_script_path" "$genre"
}

play-all-music() {
    mpc add /
    mpc shuffle
    mpc play
    notify-send -i "$icon" "MPD" "Playing all tracks!"
}

show-menu() {
    local all_albums
    local album
    all_albums=$(mpc ls)

    while true; do
        album=$(echo -e " EXIT\n Play All\n Clear Queue\n Show Genres\n况 Show All\n$all_albums" | \
        rofi -dmenu -only-match -i \
        -theme "$rofi_theme" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -theme-str 'entry {placeholder: "Play...";}' \
        -theme-str 'listview {lines: 15;}' \
        -no-show-icons)

        case "$album" in
            *EXIT) exit ;;
            *Play\ All) play-all-music && exit ;;
            *Clear\ Queue) . "$queue_script_path" clear-music;;
            *Show\ Genres) show-genres ;;
            *Show\ All) show-all-music ;;
            *) add-album "$album" ;;
        esac
    done
}

show-menu
