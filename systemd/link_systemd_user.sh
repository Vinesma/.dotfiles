#!/bin/bash

# Soft link user systemd files from this repo to $HOME/.config/systemd/user/, forcing overwrites

path="systemd/user"
origin="$HOME/.dotfiles/$path"
dest="$HOME/.config/$path"

mkdir -p "$dest"
ln -sfv "$origin"/* "$dest"

printf "%s\n" "Files linked successfully."