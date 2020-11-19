#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing suite of apps."
config-by-file "$pack_lists/miscellaneous"

## MUSIC PLAYER ##
arrow-msg "Configuring mpd and auxiliaries."
add-to-autostart 'if [[ ! -s ~/.config/mpd/pid ]]; then'
add-to-autostart "    mpc"
add-to-autostart "    mpc random on"
add-to-autostart "    mpc repeat on"
add-to-autostart "    mpc crossfade 2"
add-to-autostart 'fi'

header-msg "Installing youtube-dl:"
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
