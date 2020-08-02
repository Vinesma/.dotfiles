#!/bin/bash

applets="redshift"

# DIRS
mcf_redshift="$HOME/.config"
dcf_redshift="$HOME/.dotfiles/redshift/*"

echo "==> Installing applets"
sudo pacman -Syu $applets \
    && echo "redshift &" >> "$HOME"/.xprofile \
    && echo "-> Configuring redshift..." \
    && cp -v "$dcf_redshift" "$mcf_redshift"/ \
    && echo "-> Done." \
    || echo "-> Failed..."

