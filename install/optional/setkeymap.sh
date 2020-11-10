#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

keymp="br"

header-msg "Setting keymap."
localectl --no-convert set-x11-keymap $keymp
arrow-msg "Keymap set, a restart is required."
