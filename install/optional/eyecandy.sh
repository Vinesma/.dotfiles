#!/bin/sh

apps="feh picom lxappearance python-pywal"
theming="matcha-gtk-theme papirus-icon-theme ttf-bitstream-vera ttf-anonymous-pro"

echo "- Installing some eyecandy stuff"
sudo pacman -Syu "$apps"
echo

echo "- Installing some themes and fonts"
sudo pacman -S "$theming"
echo

echo "Done."
