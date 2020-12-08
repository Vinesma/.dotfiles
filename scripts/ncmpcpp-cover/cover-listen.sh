#!/bin/bash

image_cover="/tmp/album_cover.png"

add_cover() {
    kitty +kitten icat --clear
    kitty +kitten icat "$image_cover"
}

export PS1=''

if [[ ! -f "$image_cover" ]]; then
    cp "$HOME/.dotfiles/scripts/ncmpcpp-cover/default_cover.png" "$image_cover"
fi

while inotifywait -q -q -e close_write "$image_cover"; do
    add_cover
done
