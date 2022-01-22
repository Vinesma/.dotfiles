#!/usr/bin/env bash
#
# Setup paru, a feature packed AUR helper.

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://aur.archlinux.org/paru.git

# -- SETUP --
mkdir -p "$WORK_DIR"
sudo pacman -Syu --needed base-devel

# -- ACT --
cd "$WORK_DIR" || exit 1

git clone "$SOURCE"
cd paru || exit 1
makepkg -si --noconfirm

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"