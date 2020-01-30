#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGDIR="$HOME/.config"
clear
git pull
echo
echo "Creating links... may overwrite some files."

#mpv
MPVDIR="$CONFIGDIR/mpv"
ln -svf ${BASEDIR}/mpv/mpv.conf ${MPVDIR}/mpv.conf
ln -svf ${BASEDIR}/mpv/input.conf ${MPVDIR}/input.conf
ln -svf ${BASEDIR}/mpv/input.conf.save ${MPVDIR}/input.conf.save
echo
echo "Established 'mpv' link."

#Clementine
CLEMENTINEDIR="$CONFIGDIR/Clementine"
ln -svf ${BASEDIR}/Clementine/Clementine.conf ${CLEMENTINEDIR}/Clementine.conf
echo
echo "Established 'Clementine' link."

#qBittorrent
QBITTORRENTDIR="$CONFIGDIR/qBittorrent"
ln -svf ${BASEDIR}/qBittorrent ${QBITTORRENTDIR}
echo
echo "Established 'qBittorrent' link."

#.bashrc
ln -svf ${BASEDIR}/.bashrc ~/.bashrc
echo
echo "Established '.bashrc' link."

#Aliases
ln -svf ${BASEDIR}/.bash_aliases ~/.bash_aliases
echo
echo "\nEstablished '.bash_aliases' link."
