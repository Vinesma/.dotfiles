#!/bin/sh

numpad="numlockx"

echo "- Installing numpad helper"
sudo pacman -Syu "$numpad"
echo "numlockx &" >> "$HOME"/.xprofile
echo

echo "Done."
