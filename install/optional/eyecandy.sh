#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing eyecandy/fonts."
config-by-file "$pack_lists/eyecandy"

arrow-msg "Initializing feh wallpaper."
add-to-autostart 'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &'
