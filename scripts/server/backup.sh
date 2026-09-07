#!/usr/bin/env bash

DRIVE_DEVICE="/dev/sdb1"
MAPPED_NAME="crypt"
MOUNT_POINT="/mnt/ssd"
SOURCE_SERVER=serverpi_local
SOURCE_PATH="/mnt/storage/"

die() {
    printf "Error: %s\n" "$1"
    exit 1
}

cleanup() {
    printf "%s\n" "Unmounting drive..."
    if ! sudo umount "$MOUNT_POINT"; then
        die "Failed to unmount $MOUNT_POINT."
    fi

    printf "%s\n" "Closing encrypted drive..."
    if ! sudo cryptsetup close "$MAPPED_NAME"; then
        die "Failed to close encrypted drive."
    fi
}

# Authenticate once
sudo -v

# Keep sudo credentials alive while this script runs
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Make sure the background keepalive process dies with this script
KEEPALIVE_PID=$!
trap 'kill "$KEEPALIVE_PID" 2>/dev/null' EXIT

printf "%s\n" "Decrypting backup drive..."
if ! sudo cryptsetup open "$DRIVE_DEVICE" "$MAPPED_NAME"; then
    die "Failed to decrypt backup drive."
fi

printf "%s\n" "Mounting decrypted drive..."
if ! sudo mkdir -p "$MOUNT_POINT"; then
    die "Failed to create mount point $MOUNT_POINT."
fi

if ! sudo mount "/dev/mapper/$MAPPED_NAME" "$MOUNT_POINT"; then
    die "Failed to mount /dev/mapper/$MAPPED_NAME to $MOUNT_POINT."
fi

printf "%s\n" "Starting backup..."
rsync -aHAX --delete --info=progress2 "$SOURCE_SERVER":"$SOURCE_PATH" "$MOUNT_POINT"

cleanup

printf "%s\n" "Backup completed successfully."

# Check if shutdown option is requested
if [[ "$1" == "--shutdown" ]] || [[ "$1" == "-s" ]]; then
    printf "%s\n" "Shutting down system..."
    shutdown now
fi

exit 0