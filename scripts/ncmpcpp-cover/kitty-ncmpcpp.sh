#!/bin/bash

# Launch a kitty window with 2 ncmpcpp instances and free window that can be used for album art.

script_folder="$HOME/.dotfiles/scripts/ncmpcpp-cover/"

launch-music-player() {
    kitty \
        -T "ncmpcpp" \
        -o allow_remote_control=yes \
        --session "$script_folder/ncmpcpp.session" \
        --listen-on unix:/tmp/kitty-ncmpcpp &
}

send-options() {
    kitty @ --to unix:/tmp/kitty-ncmpcpp resize-window -a horizontal -i 34
}

launch-music-player && sleep 0.4 && send-options
