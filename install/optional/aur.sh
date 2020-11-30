#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Install AUR packages now?"
info-msg "You can always install it later on, but some fonts may be lacking until then."
info-msg "This will also install conflicting packages on top of official packages, the user must accept this."
read -r answer_aur

if [[ "$answer_aur" == @(y|Y) ]]; then
    header-msg "Installing AUR packages"
    install-aur-file "$pack_lists/yay"
fi
