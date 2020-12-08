#!/bin/bash

image_cover="/tmp/album_cover.png"
music_dir="$HOME/Music"
cover_size="400"

file="$music_dir/$(mpc --format %file% current)"
album="${file%/*}"
# search for cover image
art=$(find "$album" -maxdepth 1 | grep -m 1 ".*\.\(jpg\|png\|gif\|bmp\)")
if [ "$art" = "" ]; then
  art="$HOME/.dotfiles/scripts/ncmpcpp-cover/default_cover.png"
fi
# copy and resize image to destination
# cp "$art" "$image_cover"
ffmpeg -loglevel 0 -y -i "$art" -vf "scale=$cover_size:-1" "$image_cover"
