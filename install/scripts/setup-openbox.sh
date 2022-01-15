#!/usr/bin/env bash

# Setup Openbox themes and other stuff

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://github.com/Vinesma/walbox.git

# -- SETUP --
mkdir -p "$WORK_DIR"

# -- ACT --
cd "$WORK_DIR" || exit 1

# Setup walbox theme
git clone $SOURCE
cd walbox || exit 1
# shellcheck source=/dev/null
. install.sh

# Link my autostart to openbox's autostart
ln -sfv "$HOME"/.autostart "$HOME"/.config/openbox/autostart

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"
