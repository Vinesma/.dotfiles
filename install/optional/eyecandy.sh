#!/bin/bash

apps="feh picom lxappearance python-pywal"
theming="$HOME/.dotfiles/install/optional/list_theming"
mcf_picom="$HOME/.config/picom"
dcf_picom="$HOME/.dotfiles/picom/*"

## INSTALL ##
echo "==> Installing some eyecandy stuff"
sudo pacman -Syu $apps

## INIT FEH WALLPAPER ##
echo 'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &' >> "$HOME"/.autostart

## PICOM ##
echo "-> Configuring picom..."
    mkdir -pv "$mcf_picom"/ \
    && cp -v "$dcf_picom" "$mcf_picom"/ \
    && echo "picom &" >> "$HOME"/.autostart
echo

## THEMES & FONTS ##
echo "==> Installing some themes and fonts"
sudo pacman -S - < "$theming"
echo

echo "-> Done."
