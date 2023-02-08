#!/usr/bin/env bash

music_dir="$HOME/Music"

file="$music_dir/$(mpc --format %file% current)"
album="${file%/*}"

# search for cover image
art=$(find "$album" -maxdepth 1 | grep -m 1 "cover\.\(jpg\|png\|bmp\)")
body=$(mpc --format '\n[[%artist% - ]%title%[\n%album%]]|[%file%[\n%album%]]' current | sed -E 's/\|/, /g')

notify-send -r 1212 -h "string:image-path:$art" "NOW PLAYING" "$body"