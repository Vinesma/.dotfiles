#!/usr/bin/env bash

# Quickly setup rclone on this machine.
#
#

config_source="$HOME/Sync/rclone/rclone.conf"
config_dir="$HOME/.config/rclone/"

printf "%s\n" "Installing rclone"
curl https://rclone.org/install.sh | sudo bash

if [ -e "$config_source" ]; then
    mkdir -p "$config_dir"
    cp -v "$config_source" "$config_dir/rclone.conf"
else
    printf "%s" "Configuration file not found! Create one using ´rclone config´ or place it manually in '$config_dir'."
fi