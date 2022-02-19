#!/usr/bin/env bash

# Setup these mpv scripts
# SPONSORBLOCK

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://codeberg.org/jouni/mpv_sponsorblock_minimal.git
SOURCE_DIR="mpv_sponsorblock_minimal"
SOURCE_FILE="sponsorblock_minimal.lua"
SCRIPT_DIR=$HOME/.config/mpv/scripts

# -- SETUP --
mkdir -p "$WORK_DIR"
mkdir -p "$DESTINATION"

# -- ACT --
cd "$WORK_DIR" || exit 1

# SPONSORBLOCK
git clone "$SOURCE"
cd $SOURCE_DIR || exit 1
# Don't skip these categories
sed -i 's/,"interaction"//' $SOURCE_FILE
sed -i 's/,"selfpromo"//' $SOURCE_FILE
mv -f $SOURCE_FILE "$SCRIPT_DIR"

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"
