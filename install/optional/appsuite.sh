#!/bin/sh

app_list="htop scrot neofetch mpv qbittorrent gimp inkscape steam-manjaro newsboat wine syncthing anki nodejs npm quodlibet mpd mpc ncmpcpp rofi"

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
mcf_rofi="$HOME/.config/rofi"
dcf_rofi="$HOME/.dotfiles/rofi/*"

echo "- Installing suite of apps"
sudo pacman -Syu $app_list
echo "Configuring mpv..."
mkdir -p $mcf_mpv
cp $dcf_mpv $mcf_mpv
echo "Configuring youtube-dl..."
mkdir -p $mcf_youtubedl
cp $dcf_youtubedl $mcf_youtubedl
echo "Configuring newsboat..."
mkdir -p $mcf_newsboat
cp $dcf_newsboat $mcf_newsboat
echo "Copying qtile config over..."
cp $dcf_qtile $mcf_qtile
echo
echo "Copying polybar config over..."
mkdir -p $mcf_polybar
cp $dcf_polybar $mcf_polybar
echo
echo "Configuring mpd and auxiliaries..."
mkdir -p $mcf_mpd
cp $dcf_mpd $mcf_mpd
echo "[ ! -s ~/.config/mpd/pid ] && mpd" >> $HOME/.xprofile
mkdir -p $mcf_ncmpcpp
cp $dcf_ncmpcpp $mcf_ncmpcpp
echo
echo "Configuring rofi..."
mkdir -p $mcf_rofi
cp $dcf_rofi $mcf_rofi

echo "Done."
