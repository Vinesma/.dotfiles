#!/bin/sh

echo "-> Copying templates to pywal folder...";echo
cp -v "$HOME"/.dotfiles/pywal/templates/* "$HOME/.config/wal/templates/"
echo

echo "-> Done."
