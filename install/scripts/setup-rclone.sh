#!/usr/bin/env bash

# Setup rclone, a file storage manager.

USB_NAME=OTDRIVE
SOURCE=https://rclone.org/install.sh
RCLONE_CONFIG_DIR="$HOME/.config/rclone/"
declare -a CONFIG_SOURCES=(
    "/run/media/$USER/$USB_NAME/rclone/rclone.conf"
    "/media/$USER/$USB_NAME/rclone/rclone.conf"
    "/mnt/usb/$USB_NAME/rclone/rclone.conf"
    "$HOME/Sync/rclone/rclone.conf"
)
TEMP_FILE=$(mktemp)

# -- ACT --
curl "$SOURCE" -o "$TEMP_FILE" && sudo bash "$TEMP_FILE"

found=0
for i in "${!CONFIG_SOURCES[@]}"; do
    if [ -e "${CONFIG_SOURCES[i]}" ]; then
        mkdir -p "$RCLONE_CONFIG_DIR"
        cp -v "${CONFIG_SOURCES[i]}" "$RCLONE_CONFIG_DIR/rclone.conf"
        found=1
    fi
done

if [ $found -ne 1 ]; then
    printf "%s\n" "Configuration file not found! Create one using ´rclone config´ or place it manually in '$RCLONE_CONFIG_DIR'."
fi

# -- CLEANUP --
rm "$TEMP_FILE"