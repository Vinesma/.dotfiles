#!/bin/sh

applets="redshift"

# DIRS
mcf_redshift="$HOME/.config"
dcf_redshift="$HOME/.dotfiles/redshift/*"

echo "- Installing applets"
sudo pacman -Syu $applets
echo "redshift-gtk &" >> $HOME/.xprofile
echo "Configuring redshift..."
cp $dcf_redshift $mcf_redshift/
echo

echo "Done."
