#!/bin/bash

image_cover="/tmp/album_cover.png"
sleep_timer=0.5

# Draw cover to screen using kitty's icat
add_cover() {
    clear
    kitty +kitten icat --silent "$image_cover"
}

# Remove bash prompt
export PS1=''

if [[ ! -f "$image_cover" ]]; then
    cp "$HOME/.dotfiles/scripts/ncmpcpp-cover/default_cover.png" "$image_cover"
fi

# Pause for the window to be properly resized
# Listen for changes
while inotifywait -q -q -e close_write "$image_cover"; do
    sleep "$sleep_timer" && sleep_timer=0 && add_cover
done
