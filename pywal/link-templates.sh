#!/bin/sh

# pywal dirs
pywal_templates="$HOME/.cache/wal"

# templates
dunst_template="$pywal_templates/colors-dunst"
dunst_config="$HOME/.config/dunst/dunstrc"

echo "Linking templates to configs..."
echo "- DUNST"
ln -sfv $dunst_template $dunst_config
echo

echo "Done."
