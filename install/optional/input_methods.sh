#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing language engine."
install-package fcitx fcitx-mozc fcitx-configtool

arrow-msg "Initializing language engine."
add-to-autostart "fcitx &"
arrow-msg "Run these commands to configure the language engine:"
info-msg "$ fcitx"
info-msg "$ fcitx-configtool"
info-msg "Then restart the program (right click on systray icon) to solidify changes."
