#!/bin/sh

# Load helper functions
. "$HOME/.dotfiles/install/helper-functions.sh"

# $1 = name of program
# $2 = name of template file
create-link-templates() {
    arrow-msg "$1"
    ln -sfv "$HOME/.dotfiles/pywal/templates/$2" "$HOME/.config/wal/templates/$2"
    echo
}

# $1 = name of program
# $2 = name of template file
# $3 = path relative to the config folder
create-link-to-config-diff() {
    arrow-msg "$1"
    ln -sfv "$HOME/.cache/wal/$2" "$HOME/.config/$3"
    echo
}

arrow-msg "Linking dotfile templates to pywal config folder."

create-link-templates "DUNST" "colors-dunst"
create-link-templates "POLYBAR" "colors-polybar"

arrow-msg "Linking pywal output to configs."

create-link-to-config-diff "DUNST" "colors-dunst" "dunst/dunstrc"
create-link-to-config-diff "POLYBAR" "colors-polybar" "polybar/config"

arrow-msg "Done."
