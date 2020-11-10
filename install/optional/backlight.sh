#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing a backlight utility."
install-package xorg-xbacklight
info-msg "$ xbacklight -set 12"
