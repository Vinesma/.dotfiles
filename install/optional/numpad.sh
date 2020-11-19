#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing numpad helper."
install-package numlockx
arrow-msg "Initializing numpad helper."
add-to-autostart 'numlockx &'
