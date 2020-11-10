#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing suite of apps."
config-by-file "$pack_lists/miscellaneous"

arrow-msg "Initializing polybar."
echo '. $HOME/.config/polybar/launch.sh &' >> "$HOME/.autostart"

## MUSIC PLAYER ##
arrow-msg "Configuring mpd and auxiliaries."
echo 'if [[ ! -s ~/.config/mpd/pid ]]; then' >> "$HOME/.autostart"
echo "    mpc" >> "$HOME/.autostart"
echo "    mpc random on" >> "$HOME/.autostart"
echo "    mpc repeat on" >> "$HOME/.autostart"
echo "    mpc crossfade 2" >> "$HOME/.autostart"
echo 'fi' >> "$HOME/.autostart"

header-msg "Installing youtube-dl:"
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
