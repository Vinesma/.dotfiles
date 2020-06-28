#!/bin/sh

apps="feh picom lxappearance python-pywal"
theming="matcha-gtk-theme papirus-icon-theme ttf-bitstream-vera ttf-anonymous-pro otf-ipafont noto-fonts-emoji ttf-nerd-fonts-symbols"
mcf_picom="$HOME/.config/picom"
dcf_picom="$HOME/.dotfiles/picom/*"

echo "- Installing some eyecandy stuff"
sudo pacman -Syu $apps
echo 'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &' >> $HOME/.xprofile
echo "picom &" >> $HOME/.xprofile
echo "Configuring picom..."
mkdir -p $mcf_picom/
cp $dcf_picom $mcf_picom/
echo

echo "- Installing some themes and fonts"
sudo pacman -S $theming
echo

echo "Done."
