#!/usr/bin/env bash
#
# Setup starship, a shell prompt.

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://starship.rs/install.sh

# -- SETUP --
if [ ! -d "$WORK_DIR" ]; then
    mkdir "$WORK_DIR" || { printf "%s\n" "FAILED: creating $WORK_DIR."; exit 1; }
fi

# -- ACT --
cd "$WORK_DIR" || exit 1

curl -fsSL "$SOURCE" -o install.sh
sh install.sh

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"