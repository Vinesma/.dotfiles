#!/usr/bin/env bash

# Setup Openbox themes and other stuff

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://github.com/Vinesma/walbox.git

# -- SETUP --
if [ ! -d "$WORK_DIR" ]; then
    mkdir "$WORK_DIR" || { printf "%s\n" "FAILED: creating $WORK_DIR."; exit 1; }
fi

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
