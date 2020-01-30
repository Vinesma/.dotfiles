#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGDIR="$HOME/.config"
clear
echo "\nCreating links... may overwrite some files."

#mpv
MPVDIR="$CONFIGDIR/mpv"
ln -sv ${BASEDIR}/mpv/mpv.conf ${MPVDIR}/mpv.conf
ln -sv ${BASEDIR}/mpv/input.conf ${MPVDIR}/input.conf
ln -sv ${BASEDIR}/mpv/input.conf.save ${MPVDIR}/input.conf.save
echo "\nEstablished 'mpv' link."

#Clementine
CLEMENTINEDIR="$CONFIGDIR/Clementine"
ln -sv ${BASEDIR}/Clementine/Clementine.conf ${CLEMENTINEDIR}/Clementine.conf
echo "\nEstablished 'Clementine' link."

#qBittorrent
QBITTORRENTDIR="$CONFIGDIR/qBittorrent"
ln -sv ${BASEDIR}/qBittorrent ${QBITTORRENTDIR}
echo "\nEstablished 'qBittorrent' link."

#.bashrc
ln -sv ${BASEDIR}/.bashrc ~/.bashrc
echo "\nEstablished '.bashrc' link."

#Aliases
ln -sv ${BASEDIR}/.bash_aliases ~/.bash_aliases
echo "\nEstablished '.bash_aliases' link."

