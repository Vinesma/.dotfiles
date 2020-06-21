#!/bin/sh

# pywal dirs
pywal_templates="$HOME/.cache/wal"

# templates
dunst_template="$pywal_templates/colors-dunst"
dunst_config="$HOME/.config/dunst/dunstrc"
polybar_template="$pywal_templates/colors-polybar"
polybar_config="$HOME/.config/polybar/config"

echo "Linking templates to configs..."
echo "- DUNST"
ln -sfv $dunst_template $dunst_config
echo
echo "- POLYBAR"
ln -sfv $polybar_template $polybar_config
echo

echo "Done."
