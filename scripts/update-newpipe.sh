#!/usr/bin/env bash

SOURCE="https://github.com/polymorphicshade/NewPipe/releases/latest"
WORK_DIR=$(mktemp -d)
CURRENT_DIR=$(pwd)
NEWPIPE_DIR=$HOME/Sync/Newpipe

cd "$WORK_DIR" || exit 1

curl -Ls "$SOURCE" -o index.html
link_piece=$(grep -E 'href=.*\.apk' index.html | cut -d '"' -f 2)
version=${link_piece##*_}
full_link="https://github.com$link_piece"

mkdir -p "$NEWPIPE_DIR"
if [ ! -f "$NEWPIPE_DIR/NewPipe_SponsorBlock_$version" ]; then
    rm -f "$NEWPIPE_DIR"/NewPipe_SponsorBlock_*
    curl -L "$full_link" -o "$NEWPIPE_DIR/NewPipe_SponsorBlock_$version"
else
    printf "%s\n" "No new version found, ${version%.*} is the latest."
fi

cd "$CURRENT_DIR" || exit 1
rm -rf "$WORK_DIR"
