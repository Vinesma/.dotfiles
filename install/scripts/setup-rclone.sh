#!/usr/bin/env bash

# Setup/update rclone, a file storage manager.

USB_NAME=OTDRIVE
SOURCE=https://rclone.org/install.sh
RCLONE_CONFIG_DIR="$HOME/.config/rclone/"
declare -a CONFIG_SOURCES=(
    "/run/media/$USER/$USB_NAME/rclone/rclone.conf"
    "/media/$USER/$USB_NAME/rclone/rclone.conf"
    "/mnt/usb/$USB_NAME/rclone/rclone.conf"
    "$HOME/Sync/rclone/rclone.conf"
)

# -- SETUP --
if [ ! -d "$WORK_DIR" ]; then
    mkdir "$WORK_DIR" || { printf "%s\n" "FAILED: creating $WORK_DIR."; exit 1; }
fi

# -- ACT --
cd "$WORK_DIR" || exit 1

curl "$SOURCE" -o install.sh && sudo bash install.sh

found=0
for i in "${!CONFIG_SOURCES[@]}"; do
    if [ -e "${CONFIG_SOURCES[i]}" ]; then
        mkdir -p "$RCLONE_CONFIG_DIR"
        cp -vf "${CONFIG_SOURCES[i]}" "$RCLONE_CONFIG_DIR/rclone.conf"
        found=1
    fi
done

if [ $found -ne 1 ]; then
    printf "%s\n" "Configuration file not found! Create one using 'rclone config' or place it manually in '$RCLONE_CONFIG_DIR'."
fi

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"
