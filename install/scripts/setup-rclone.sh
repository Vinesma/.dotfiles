#!/usr/bin/env bash

# Setup/update rclone, a file storage manager.

WORK_DIR=$HOME/.dotfiles/install/workdir/
USB_NAME=OTDRIVE
SOURCE=https://rclone.org/install.sh
ZSH_COMPLETION_DIR=/usr/share/zsh/functions/Completion/X
RCLONE_CONFIG_DIR="$HOME/.config/rclone"
declare -a CONFIG_SOURCES=(
    "/run/media/$USER/$USB_NAME/rclone/rclone.conf"
    "/media/$USER/$USB_NAME/rclone/rclone.conf"
    "/mnt/usb/$USB_NAME/rclone/rclone.conf"
    "$HOME/Sync/rclone/rclone.conf"
)

# -- SETUP --
mkdir -p "$WORK_DIR"

# -- ACT --
cd "$WORK_DIR" || exit 1

if ! command -v rclone > /dev/null; then
    # shellcheck disable=SC2015
    curl "$SOURCE" -o install.sh \
    && sudo bash install.sh \
    || { printf "%s\n" "FAILED: installation failed."; exit 1; }
else
    sudo rclone selfupdate
fi

if [ -d $ZSH_COMPLETION_DIR ]; then
    printf "%s\n" "Generating completions for zsh..."
    rclone completion zsh | sudo tee ${ZSH_COMPLETION_DIR}/_rclone > /dev/null
fi

for i in "${!CONFIG_SOURCES[@]}"; do
    if [ -f "${CONFIG_SOURCES[i]}" ]; then
        mkdir -p "$RCLONE_CONFIG_DIR"
        printf "%s\n" "Found configuration file!"
        cp -vf "${CONFIG_SOURCES[i]}" "${RCLONE_CONFIG_DIR}/rclone.conf"
        break
    fi
done

if [ ! -f "${RCLONE_CONFIG_DIR}/rclone.conf" ]; then
    printf "%s\n" "Configuration file not found! Create one using 'rclone config' or place it manually in '$RCLONE_CONFIG_DIR'."
fi

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"
