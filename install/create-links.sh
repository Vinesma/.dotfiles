#!/bin/bash

config_dir="$HOME/.config"
dotfiles_dir="$HOME/.dotfiles"

# Load helper functions
. "$dotfiles_dir/install/helper-functions.sh"

arrow-msg "Linking files, this makes sure any changes in the filesystem get reflected on the repository and can be committed or reverted."
info-msg "Files will be overwritten."

# Used to create links between the repository and $HOME
create-link-to-home() {
    arrow-msg "$1"
    ln -sfv "$dotfiles_dir"/"$2" "$HOME"/"$2"
    echo
}

# Used to create links between the repository and the config directory
create-link-to-config() {
    arrow-msg "$1"
    ln -sfv "$dotfiles_dir"/"$2" "$config_dir"/"$2"
    echo
}

# Used to create links between the repository and the config directory
# Use when the paths are not exactly the same
create-link-to-config-diff() {
    arrow-msg "$1"
    ln -sfv "$dotfiles_dir"/"$2" "$config_dir"/"$3"
    echo
}

create-link-to-home "BASHRC" ".bashrc"
create-link-to-home "ZSH" ".zshrc"
create-link-to-config "NANO" "nano/nanorc"
create-link-to-config "KITTY" "kitty/kitty.conf"
create-link-to-config-diff "REDSHIFT" "redshift/redshift.conf" "redshift.conf"
create-link-to-config "NEWSBOAT" "newsboat/urls"
create-link-to-config "NEWSBOAT" "newsboat/config"
create-link-to-config "MPV" "mpv/mpv.conf"
create-link-to-config "MPV" "mpv/input.conf"
create-link-to-config "YOUTUBE-DL" "youtube-dl/config"
create-link-to-config "PICOM" "picom/picom.conf"
create-link-to-config "MPD" "mpd/mpd.conf"
create-link-to-config "NCMPCPP" "ncmpcpp/config"
create-link-to-config "NCMPCPP" "ncmpcpp/bindings"
create-link-to-config "ROFI" "rofi/config.rasi"
create-link-to-config "QTILE" "qtile/config.py"
create-link-to-config "NVIM" "nvim/init.vim"
create-link-to-config "ZATHURA" "zathura/zathurarc"

arrow-msg "Done."
