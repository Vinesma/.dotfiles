#!/bin/sh

create-link-templates() {
    # $1 = name of template file
    ln -sfv "$HOME/.dotfiles/pywal/templates/$1" "$HOME/.config/wal/templates/$1"
    echo
}

create-link-config() {
    # $1 = name of template file
    # $2 = path relative to the config folder
    ln -sfv "$HOME/.cache/wal/$1" "$HOME/.config/$2"
    echo
}

echo "-> Linking dotfile templates to pywal config folder..."

echo "- DUNST";echo
create-link-templates "colors-dunst"
echo "- POLYBAR";echo
create-link-templates "colors-polybar"

echo "-> Done."
echo "-> Linking pywal output to configs..."

echo "- DUNST";echo
create-link-config "colors-dunst" "dunst/dunstrc"

echo "- POLYBAR";echo
create-link-config "colors-polybar" "polybar/config"

echo "-> Done."
