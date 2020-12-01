#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"
templates_folder="$HOME/.config/wal/templates"
origin_folder="$HOME/.dotfiles/pywal-templates/"

# Load helper functions
. "$main_folder/helper-functions.sh"

# Use this if your configs ever unlink themselves
create-link-function "$origin_folder/colors-dunst"        "$templates_folder/colors-dunst"
create-link-function "$origin_folder/colors-main-polybar" "$templates_folder/colors-main-polybar"
create-link-function "$origin_folder/colors-polybar"      "$templates_folder/colors-polybar"
