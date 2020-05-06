#!/bin/sh

applets="network-manager-applet pasystray"

echo "- Installing applets"
sudo pacman -Syu "$applets"
echo

echo "Done."
