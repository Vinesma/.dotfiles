#!/bin/bash

# Choose several options for wallpaper setting.
# Dependencies:
# feh, rofi

wallpaper_dir="$HOME/Pictures/Wallpapers"
files_folder="$HOME/.dotfiles/scripts/bg-setter"
resolution=$(xrandr | grep '*' | awk '{printf $1}')
width=$(echo "$resolution" | cut -d 'x' -f 1)
height=$(echo "$resolution" | cut -d 'x' -f 2)

load-config() {
    if [[ -e "$files_folder/saturation" ]]; then
        saturation_amount=$(cat "$files_folder/saturation")
    else
        saturation_amount=1
    fi

#    if [[ -e "$files_folder/transparency" ]]; then
#        transparency_amount=$(cat "$files_folder/transparency")
#    else
#        transparency_amount=1
#    fi
}

set-saturation() {
    local value
    value=$(rofi -dmenu -p 'Saturation' -mesg "Type a value between 0.0 and 1.0" -lines 0)

    echo "$value" > "$files_folder/saturation"
}

set-transparency() {
    local value
    value=$(rofi -dmenu -p 'Transparency' -mesg "Type a value between 0.0 and 1.0" -lines 0)

    echo "$value" > "$files_folder/transparency"
}

clear-cache() {
    wal -c
}

show-chooser() {
    local wallpaper
    wallpaper=$(feh -A ';echo %F' --max-dimension "$width"x"$height" -d -F "$wallpaper_dir")
    wallpaper=$(echo "$wallpaper" | tail -n 1)

    if [[ -n "$wallpaper" ]]; then
        . "$files_folder/set-bg.sh" "$wallpaper" --saturate "$saturation_amount"
    fi
}

show-menu() {
    local option
    option=$(echo -e "1. Pick wallpapers\n2. Clear cache\n3. Set saturation\n4. Set transparency\n5. Exit" | rofi -dmenu -only-match -p 'option' -format 'd' -mesg "Saturation: $saturation_amount" -lines 5)

    case "$option" in
        1) show-chooser ;;
        2) clear-cache ;;
        3) set-saturation ;;
        4) set-transparency ;;
        *) exit ;;
    esac
}

while true; do
    load-config
    show-menu
done
