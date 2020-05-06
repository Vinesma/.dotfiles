#!/bin/sh

app_list="firefox mpv youtube-dl qbittorrent gimp inkscape redshift steam-manjaro newsboat wine syncthing anki nodejs npm albert"

echo "- Installing suite of apps"
sudo pacman -Syu "$app_list"
echo

echo "Done."
