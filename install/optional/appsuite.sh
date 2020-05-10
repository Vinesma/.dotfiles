#!/bin/sh

app_list="mpv youtube-dl qbittorrent gimp inkscape redshift steam-manjaro newsboat wine syncthing anki nodejs npm albert cmus"

echo "- Installing suite of apps"
sudo pacman -Syu $app_list
echo

echo "Done."
