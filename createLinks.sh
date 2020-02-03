#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGDIR="$HOME/.config"
git pull
clear
echo "Creating links... may overwrite some files.";echo

echo "MPV:";echo
MPVDIR="$CONFIGDIR/mpv"
ln -svf ${BASEDIR}/mpv/mpv.conf ${MPVDIR}/mpv.conf
ln -svf ${BASEDIR}/mpv/input.conf ${MPVDIR}/input.conf
ln -svf ${BASEDIR}/mpv/input.conf.save ${MPVDIR}/input.conf.save
echo

echo "CLEMENTINE:";echo
CLEMENTINEDIR="$CONFIGDIR/Clementine"
ln -svf ${BASEDIR}/Clementine/Clementine.conf ${CLEMENTINEDIR}/Clementine.conf
echo

echo "QBITTORRENT:";echo
QBITTORRENTDIR="$CONFIGDIR/qBittorrent"
ln -svf ${BASEDIR}/qBittorrent ${QBITTORRENTDIR}
echo

echo "YOUTUBE-DL";echo
YOUTUBEDLDIR="$CONFIGDIR/youtube-dl"
ln -svf ${BASEDIR}/youtube-dl ${YOUTUBEDLDIR}
echo

echo ".BASHRC:";echo
ln -svf ${BASEDIR}/.bashrc ~/.bashrc
echo

echo "ALIASES:";echo
ln -svf ${BASEDIR}/.bash_aliases ~/.bash_aliases
echo
