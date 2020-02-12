#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$HOME/.config"
git pull
clear
echo "Creating links... may overwrite some files.";echo

echo "MPV:";echo
mpv_dir="$config_dir/mpv"
ln -svf ${BASEDIR}/mpv/mpv.conf ${mpv_dir}/mpv.conf
ln -svf ${BASEDIR}/mpv/input.conf ${mpv_dir}/input.conf
ln -svf ${BASEDIR}/mpv/input.conf.save ${mpv_dir}/input.conf.save
echo

echo "CLEMENTINE:";echo
clementine_dir="$config_dir/Clementine"
ln -svf ${BASEDIR}/Clementine/Clementine.conf ${clementine_dir}/Clementine.conf
echo

echo "QBITTORRENT:";echo
qbittorrent_dir="$config_dir/qBittorrent"
ln -svf ${BASEDIR}/qBittorrent ${qbittorrent_dir}
echo

echo "YOUTUBE-DL";echo
youtubedl_dir="$config_dir/youtube-dl"
ln -svf ${BASEDIR}/youtube-dl ${youtubedl_dir}
echo

echo ".BASHRC:";echo
ln -svf ${BASEDIR}/.bashrc ~/.bashrc
echo

echo "ALIASES:";echo
ln -svf ${BASEDIR}/.bash_aliases ~/.bash_aliases
echo
