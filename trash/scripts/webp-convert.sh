#!/usr/bin/env bash

DIR="${1:-.}"
MIN_FILESIZE_KB=850

{
    setopt LOCAL_OPTIONS NULL_GLOB

    cd "$DIR" || exit 1

    for FILE in *.jpg; do
        # check so that conversion only happens to files of size greater than the minimal
        if [[ $(stat -c%s "$FILE") -gt $((MIN_FILESIZE_KB * 1024)) ]]; then
            ffmpeg -i "$FILE" -compression_level 6 "${FILE%%.*}.webp" && rm "$FILE"
        fi
    done

    for FILE in *.png; do
        # check so that conversion only happens to files of size greater than the minimal
        if [[ $(stat -c%s "$FILE") -gt $((MIN_FILESIZE_KB * 1024)) ]]; then
            ffmpeg -i "$FILE" -compression_level 6 "${FILE%%.*}.webp" && rm "$FILE"
        fi
    done
}
