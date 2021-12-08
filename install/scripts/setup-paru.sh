#!/usr/bin/env bash
#
# Setup paru, a feature packed AUR helper.

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://aur.archlinux.org/paru.git

# -- SETUP --
if [ ! -d "$WORK_DIR" ]; then
    mkdir "$WORK_DIR" || { printf "%s\n" "FAILED: creating $WORK_DIR."; exit 1; }
fi

sudo pacman -Syu --needed base-devel

# -- ACT --
cd "$WORK_DIR" || exit 1

git clone "$SOURCE"
cd paru || exit 1
makepkg -si

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"