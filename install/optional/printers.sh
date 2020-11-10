#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing printer support."
install-package manjaro-printer

arrow-msg "Adding your user to sys group"
sudo gpasswd -a "$USER" sys
info-msg "Enabling printer service:"
sudo systemctl enable --now org.cups.cupsd.service
info-msg "All done, you can now go to http://localhost:631/"
info-msg "In the Administration tab you can add and manage local or networked printers and jobs."
