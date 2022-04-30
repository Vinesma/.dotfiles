#!/usr/bin/env bash
#
# Setup/update starship, a shell prompt.

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://starship.rs/install.sh

# -- SETUP --
mkdir -p "$WORK_DIR"

# -- ACT --
cd "$WORK_DIR" || exit 1

curl -fsSL "$SOURCE" -o install.sh
sh install.sh

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"
