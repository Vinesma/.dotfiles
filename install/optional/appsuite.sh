#!/bin/sh

app_list="mpv youtube-dl qbittorrent gimp inkscape steam-manjaro newsboat wine syncthing anki nodejs npm cmus"

# DIRS
mcf_mpv="$HOME/.config/mpv"
dcf_mpv="$HOME/.dotfiles/mpv/*"
mcf_youtubedl="$HOME/.config/youtube_dl"
dcf_youtubedl="$HOME/.dotfiles/youtube_dl/*"
mcf_newsboat="$HOME/.config/newsboat"
dcf_newsboat="$HOME/.dotfiles/newsboat/*"
mcf_qtile="$HOME/.config/qtile"
dcf_qtile="$HOME/.dotfiles/qtile/*"

echo "- Installing suite of apps"
sudo pacman -Syu $app_list
echo "Configuring mpv..."
mkdir -p $mcf_mpv/
cp $dcf_mpv $mcf_mpv/
echo "Configuring youtube-dl..."
mkdir -p $mcf_youtubedl/
cp $dcf_youtubedl $mcf_youtubedl/
echo "Configuring newsboat..."
mkdir -p $mcf_newsboat/
cp $dcf_newsboat $mcf_newsboat/
echo "Copying qtile config over..."
cp $dcf_qtile $mcf_qtile/
echo

echo "Done."
