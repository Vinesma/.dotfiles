#!/bin/sh

apps="feh picom lxappearance python-pywal"
theming="matcha-gtk-theme papirus-icon-theme ttf-bitstream-vera ttf-anonymous-pro otf-ipafont"

echo "- Installing some eyecandy stuff"
sudo pacman -Syu $apps
echo 'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &' >> $HOME/.xprofile
echo "picom &" >> $HOME/.xprofile
echo

echo "- Installing some themes and fonts"
sudo pacman -S $theming
echo

echo "Done."
