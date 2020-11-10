#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing touchpad tools."
install-package xorg-xinput
info-msg "$ xinput list -> Grab the device id you want to change"
info-msg "$ xinput list-props [id] -> List what can be changed"
info-msg "$ xinput set-prop [id] [prop-id] [1/0] -> non-persistent"
info-msg "You can add the command to .autostart to make it persistent, beware if the device changes id after kernel changes."
