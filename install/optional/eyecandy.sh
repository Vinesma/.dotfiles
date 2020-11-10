#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing eyecandy/fonts."
config-by-file "$pack_lists/eyecandy"

## INIT FEH WALLPAPER ##
arrow-msg "Initializing feh wallpaper."
echo 'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &' >> "$HOME/.autostart"
arrow-msg "Initializing picom."
echo "picom &" >> "$HOME"/.autostart
