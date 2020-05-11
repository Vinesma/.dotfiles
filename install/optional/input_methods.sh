#!/bin/sh

iengine="fcitx fcitx-mozc fcitx-configtool"

echo "- Installing fcitx with mozc module"
sudo pacman -Syu $iengine
echo "fcitx &" >> $HOME/.xprofile
echo "Run it once on a terminal to config, then reboot to solidify changes"

echo "Done."
