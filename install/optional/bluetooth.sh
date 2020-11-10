#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Installing bluetooth packages."
install-package bluez bluez-utils pulseaudio-bluetooth

arrow-msg "Checking if btusb module is loaded"
if lsmod | grep btusb; then
    arrow-msg "Enabling bluetooth service"
    sudo systemctl enable --now bluetooth.service
    arrow-msg "Loading pulseaudio's bluetooth modules"
    sudo echo -e "\n# Load bluetooth\nload-module module-bluetooth-policy\nload-module module-bluetooth-discover" >> /etc/pulse/system.pa
    info-msg "All done, try using 'bluetoothctl' to pair and connect to a device."
    info-msg "To automatically power on bluetooth at boot add 'AutoEnable=true' to the last line in '/etc/bluetooth/main.conf'"
    info-msg "If there are errors when trying to connect to a device, try installing 'pulseaudio-bluetooth-a2dp-gdm-fix' or checking the wiki."
else
    arrow-msg "ERROR: btusb is not loaded, check your modules."
fi
