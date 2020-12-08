#!/bin/bash

image_cover="/tmp/album_cover.png"
seconds=1

# Draw cover to screen using kitty's icat
add_cover() {
    kitty +kitten icat --clear --silent
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
    sleep "$seconds" && seconds=0 && add_cover
done
