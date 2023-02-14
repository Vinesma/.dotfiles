#!/usr/bin/env bash

# Creates a popup window for the user to select an album, then immediately starts playing.
# Dependencies:
# - mpd, mpc, rofi

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"
rofi_theme="$HOME/.cache/wal/colors-rofi-launcher"

queue_script_path="$HOME/.dotfiles/scripts/mpd/queue-music.sh"

rofi-cmd() {
    rofi \
    -dmenu \
    -only-match \
    -i \
    -theme "$rofi_theme" \
    -no-show-icons \
    "$@"
}

add-album() {
    echo "$1" | mpc add
    mpc shuffle
    mpc play
    notify-send -i "$icon" "MPD" "$1 added to queue!"
}

show-all-music() {
    local track
    local title
    track=$(mpc listall | rofi-cmd -theme-str 'listview {lines: 15;}')
    title=$(echo "$track" | sed -e 's/.*\///' -e 's/\.mp3//')

    echo "$track" | mpc add
    mpc play
    notify-send -i "$icon" "MPD" "$title added to queue!"
}

show-genres() {
    local genre
    genre=$(mpc list genre | rofi-cmd -theme-str 'listview {lines: 8;}')

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
    local menu_options
    all_albums=$(mpc ls)
    menu_options=(' EXIT' ' Play All' ' Clear Queue' ' Show Genres' '况 Show All' "$all_albums")

    while true; do
        album=$(printf "%s\n" "${menu_options[@]}" | \
        rofi-cmd \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -theme-str 'entry {placeholder: "Play...";}' \
        -theme-str 'listview {lines: 15;}')

        case "$album" in
            "${menu_options[0]}") exit ;;
            "${menu_options[1]}") play-all-music && exit 0;;
            "${menu_options[2]}") . "$queue_script_path" clear-music;;
            "${menu_options[3]}") show-genres ;;
            "${menu_options[4]}") show-all-music ;;
            *) add-album "$album" ;;
        esac
    done
}

show-menu
