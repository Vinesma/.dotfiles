#!/bin/sh

# DIRS
templates_dir="$HOME/.dotfiles/pywal/templates"

# pywal dirs
pywal_templates="$HOME/.config/wal/templates/"

echo "Copying templates to pywal folder..."
cp $templates_dir/* $pywal_templates
echo

echo "Done."
