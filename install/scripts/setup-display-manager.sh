#!/usr/bin/env bash
#
# Setup default DM configuration and create a dedicated wallpaper folder for DMs to use.

DM_NAME=lightdm
DM_CONFIG_DIR=/etc/$DM_NAME
DM_WALLPAPER_DIR=/usr/share/wallpapers
WORK_DIR=$HOME/.dotfiles/$DM_NAME

# -- SETUP --
sudo mkdir -pv $DM_WALLPAPER_DIR
sudo chmod -v 777 $DM_WALLPAPER_DIR

# -- ACT --
for file in "$WORK_DIR"/*; do
    sudo cp -vf "$file" "$DM_CONFIG_DIR"
done