#!/bin/bash

# Choose several options for wallpaper setting.
# Dependencies:
#

wallpaper_dir="$HOME/Pictures/Wallpapers"
files_folder="$HOME/.dotfiles/scripts/bg-setter"

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

show-menu() {
    echo -e "1. List wallpapers\n2. Set saturation\n3. Exit" | rofi -dmenu
}

load-config
show-menu
