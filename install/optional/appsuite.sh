#!/bin/sh

app_list="htop scrot neofetch mpv youtube-dl qbittorrent gimp inkscape steam-manjaro newsboat wine syncthing anki nodejs npm quodlibet mpd mpc ncmpcpp"

# DIRS
mcf_mpv="$HOME/.config/mpv"
dcf_mpv="$HOME/.dotfiles/mpv/*"
mcf_youtubedl="$HOME/.config/youtube-dl"
dcf_youtubedl="$HOME/.dotfiles/youtube-dl/*"
mcf_newsboat="$HOME/.config/newsboat"
dcf_newsboat="$HOME/.dotfiles/newsboat/*"
mcf_qtile="$HOME/.config/qtile"
dcf_qtile="$HOME/.dotfiles/qtile/*"
mcf_polybar="$HOME/.config/polybar"
dcf_polybar="$HOME/.dotfiles/polybar/*"
mcf_mpd="$HOME/.config/mpd"
dcf_mpd="$HOME/.dotfiles/mpd/*"
mcf_ncmpcpp="$HOME/.config/ncmpcpp"
dcf_ncmpcpp="$HOME/.dotfiles/ncmpcpp/*"

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
echo "Copying polybar config over..."
mkdir -p $mcf_polybar/
cp $dcf_polybar $mcf_polybar
echo "Configuring mpd and auxiliaries..."
mkdir -p $mcf_mpd
cp $dcf_mpd $mcf_mpd
echo "[ ! -s ~/.config/mpd/pid ] && mpd" >> $HOME/.xprofile
mkdir -p $mcf_ncmpcpp
cp $dcf_ncmpcpp $mcf_ncmpcpp
echo

echo "Done."
