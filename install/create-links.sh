#!/bin/bash

config_dir="$HOME/.config"
dotfiles_dir="$HOME/.dotfiles"

echo "==> Linking files, this makes sure any changes in the filesystem get reflected on the repository and can be committed or reverted."
echo "[i] Files will be overwritten."

create-link-config() {
    ln -sfv "$dotfiles_dir"/"$1" "$config_dir"/"$1"
    echo
}

create-link-config-diff() {
    ln -sfv "$dotfiles_dir"/"$1" "$config_dir"/"$2"
    echo
}

create-link-home() {
    ln -sfv "$dotfiles_dir"/"$1" "$HOME"/"$1"
    echo
}

echo "- BASHRC";echo
create-link-home ".bashrc"

echo "- NANO";echo
create-link-config "nano/nanorc"

echo "- KITTY";echo
create-link-config "kitty/kitty.conf"

echo "- REDSHIFT";echo
create-link-config-diff "redshift/redshift.conf" "redshift.conf"

echo "- NEWSBOAT";echo
create-link-config "newsboat/urls"
create-link-config "newsboat/config"

echo "- MPV";echo
create-link-config "mpv/mpv.conf"
create-link-config "mpv/input.conf"

echo "- YOUTUBE-DL";echo
create-link-config "youtube-dl/config"

echo "- PICOM";echo
create-link-config "picom/picom.conf"

echo "- MPD";echo
create-link-config "mpd/mpd.conf"

echo "- NCMPCPP";echo
create-link-config "ncmpcpp/config"
create-link-config "ncmpcpp/bindings"

echo "- ROFI";echo
create-link-config "rofi/config.rasi"

echo "- QTILE";echo
create-link-config "qtile/config.py"

echo "- NVIM";echo
create-link-config "nvim/init.vim"

# TEMPLATE
# echo "- {NAME}";echo
# create-link-{foo} "{path}"

echo "-> Done."
