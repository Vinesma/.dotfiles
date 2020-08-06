#!/bin/sh

create-link-config() {
    # $1 = name of template file
    # $2 = path relative to the config folder
    ln -sfv "$HOME/.cache/wal/$1" "$HOME/.config/$2"
    echo
}

echo "-> Linking templates to configs..."

echo "- DUNST";echo
create-link-config "colors-dunst" "dunst/dunstrc"

echo "- POLYBAR";echo
create-link-config "colors-polybar" "polybar/config"

echo "-> Done."
