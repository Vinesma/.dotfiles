#!/bin/sh

apps="feh picom lxappearance python-pywal"
theming="$HOME/.dotfiles/install/optional/list_theming"
mcf_picom="$HOME/.config/picom"
dcf_picom="$HOME/.dotfiles/picom/*"

## INSTALL ##
echo "- Installing some eyecandy stuff"
sudo pacman -Syu "$apps"
## INIT FEH WALLPAPER ##
echo 'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &' >> "$HOME"/.xprofile
## PICOM ##
echo "picom &" >> "$HOME"/.xprofile
echo "Configuring picom..."
mkdir -p "$mcf_picom"/
cp "$dcf_picom" "$mcf_picom"/
echo

## THEMES & FONTS ##
echo "- Installing some themes and fonts"
sudo pacman -S - < "$theming"
echo

echo "Done."
