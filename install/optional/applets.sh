#!/bin/sh

applets="pasystray"

echo "- Installing applets"
sudo pacman -Syu $applets
echo "pasystray &" >> $HOME/.xprofile
echo

echo "Done."
