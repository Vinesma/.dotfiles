#!/bin/bash

config_dir="$HOME/.config"
dotfiles_dir="$HOME/.dotfiles"

echo "==> Linking files, this makes sure any changes in the filesystem get reflected on the repository and can be committed or reverted."
echo "-> [i] Files will be overwritten."

# Used to create links between the repository and $HOME
create-link-to-home() {
    ln -sfv "$dotfiles_dir"/"$1" "$HOME"/"$1"
    echo
}

# Used to create links between the repository and the config directory
create-link-to-config() {
    ln -sfv "$dotfiles_dir"/"$1" "$config_dir"/"$1"
    echo
}

# Used to create links between the repository and the config directory
# Use when the paths are not exactly the same
create-link-to-config-diff() {
    ln -sfv "$dotfiles_dir"/"$1" "$config_dir"/"$2"
    echo
}

echo "- BASHRC";echo
create-link-to-home ".bashrc"

echo "- NANO";echo
create-link-to-config "nano/nanorc"

echo "- KITTY";echo
create-link-to-config "kitty/kitty.conf"

echo "- REDSHIFT";echo
create-link-to-config-diff "redshift/redshift.conf" "redshift.conf"

echo "- NEWSBOAT";echo
create-link-to-config "newsboat/urls"
create-link-to-config "newsboat/config"

echo "- MPV";echo
create-link-to-config "mpv/mpv.conf"
create-link-to-config "mpv/input.conf"

echo "- YOUTUBE-DL";echo
create-link-to-config "youtube-dl/config"

echo "- PICOM";echo
create-link-to-config "picom/picom.conf"

echo "- MPD";echo
create-link-to-config "mpd/mpd.conf"

echo "- NCMPCPP";echo
create-link-to-config "ncmpcpp/config"
create-link-to-config "ncmpcpp/bindings"

echo "- ROFI";echo
create-link-to-config "rofi/config.rasi"

echo "- QTILE";echo
create-link-to-config "qtile/config.py"

echo "- NVIM";echo
create-link-to-config "nvim/init.vim"

# TEMPLATE
# echo "- {NAME}";echo
# create-link-to-{foo} "{path}"

echo "-> Done."
