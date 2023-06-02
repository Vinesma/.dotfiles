#!/usr/bin/env bash

# Creates a popup window for the user to select an album, then immediately starts playing.
# Dependencies:
# - mpd, mpc, rofi/wofi

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"
queue_script_path="$HOME/.dotfiles/scripts/mpd/queue-music.sh"
session_wrofi="$HOME/.dotfiles/scripts/helpers/session-wrofi.sh"

# shellcheck source=../helpers/session-wrofi.sh
source "$session_wrofi"

add-album() {
    echo "$1" | mpc add
    mpc shuffle
    mpc play
    notify-send -i "$icon" "MPD" "$1 added to queue!"
}

show-all-music() {
    local track
    local title
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=("-theme-str" 'listview {lines: 15;}')
    else
        wrofi_args=("--lines" "15")
    fi

    track=$(mpc listall | wrofi-switch "${wrofi_args[@]}")
    title=$(echo "$track" | sed -e 's/.*\///' -e 's/\.mp3//')

    echo "$track" | mpc add
    mpc play
    notify-send -i "$icon" "MPD" "$title added to queue!"
}

show-genres() {
    local genre
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=("-theme-str" 'listview {lines: 8;}')
    else
        wrofi_args=("--lines" "8")
    fi

    genre=$(mpc list genre | wrofi-switch "${wrofi_args[@]}")

    # shellcheck source=./queue-music.sh
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
    local wrofi_args
    all_albums=$(mpc ls)
    menu_options=(' EXIT' ' Play All' ' Clear Queue' ' Show Genres' '况 Show All' "$all_albums")

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-theme-str" 'textbox-prompt-colon {str: "";}' \
            "-theme-str" 'entry {placeholder: "Play...";}' \
            "-theme-str" 'listview {lines: 15;}')
    else
        wrofi_args=("--lines" "15" "-p"  " Play...")
    fi

    while true; do
        local album;

        album=$(printf "%s\n" "${menu_options[@]}" | wrofi-switch "${wrofi_args[@]}")

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
