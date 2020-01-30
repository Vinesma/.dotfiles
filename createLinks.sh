#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "BASEDIR = ${BASEDIR}"
echo "Creating links... may overwrite some files."

#mpv
ln -s ${BASEDIR}/mpv ~/.config/mpv
echo "Established 'mpv' link."

#Clementine
ln -s ${BASEDIR}/Clementine ~/.config/Clementine
echo "Established 'Clementine' link."

#qBittorrent
ln -s ${BASEDIR}/qBittorrent ~/.config/qBittorrent
echo "Established 'qBittorrent' link."

#Aliases
ln -s ${BASEDIR}/.bash_aliases ~/.bash_aliases
echo "Established '.bash_aliases' link."

