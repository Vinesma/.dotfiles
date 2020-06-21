#!/bin/bash

config_dir="$HOME/.config"
dotfiles_dir="$HOME/.dotfiles"

echo "Linking files, this makes sure any changes in the filesystem get reflected on the repository and can be committed or reverted."
echo "Files will be overwritten."

# FORMAT: .dotfiles/ -> .config/

echo "- .BASHRC";echo
ln -sfv $dotfiles_dir/.bashrc $HOME/.bashrc
echo

echo "- NANO";echo
ln -sfv $dotfiles_dir/nano/nanorc $config_dir/nano/nanorc
echo

echo "- KITTY";echo
ln -sfv $dotfiles_dir/kitty/kitty.conf $config_dir/kitty/kitty.conf
echo

echo "- REDSHIFT";echo
ln -sfv $dotfiles_dir/redshift/redshift.conf $config_dir/redshift.conf
echo

echo "- NEWSBOAT";echo
ln -sfv $dotfiles_dir/newsboat/urls $config_dir/newsboat/urls
ln -sfv $dotfiles_dir/newsboat/config $config_dir/newsboat/config
echo

echo "- MPV";echo
ln -svf $dotfiles_dir/mpv/mpv.conf $config_dir/mpv/mpv.conf
ln -svf $dotfiles_dir/mpv/input.conf $config_dir/mpv/input.conf
echo

echo "- YOUTUBE-DL";echo
ln -sfv $dotfiles_dir/youtube-dl/config $config_dir/youtube-dl/config
echo

echo "- PICOM";echo
ln -sfv $dotfiles_dir/picom/picom.conf $config_dir/picom/picom.conf
echo

echo "- MPD";echo
ln -sfv $dotfiles_dir/mpd/mpd.conf $config_dir/mpd/mpd.conf
echo

echo "- NCMPCPP";echo
ln -sfv $dotfiles_dir/ncmpcpp/config $config_dir/mpd/config
ln -sfv $dotfiles_dir/ncmpcpp/bindings $config_dir/mpd/bindings
echo

echo "- QTILE";echo
ln -sfv $dotfiles_dir/qtile/config.py $config_dir/qtile/config.py
echo

echo "Done."
