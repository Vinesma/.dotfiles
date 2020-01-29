#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#mpv
ln -s ${BASEDIR}/mpv ~/.config/mpv

#Clementine
ln -s ${BASEDIR}/Clementine ~/.config/Clementine

#qBittorrent
ln -s ${BASEDIR}/qBittorrent ~/.config/qBittorrent

#Aliases
ln -s ${BASEDIR}/.bash_aliases ~/.bash_aliases
