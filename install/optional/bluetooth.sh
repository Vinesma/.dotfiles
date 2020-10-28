#!/bin/bash

bluetooth_tools="bluez bluez-utils pulseaudio-bluetooth"

echo "==> Installing bluetooth support"
sudo pacman -Syu $bluetooth_tools \
    && echo "-> Checking if btusb module is loaded" \
    && lsmod | grep btusb \
    && echo "-> Enabling bluetooth service" \
    && sudo systemctl enable --now bluetooth.service \
    && echo "-> Loading pulseaudio's bluetooth modules" \
    && sudo echo -e "\n# Load bluetooth\nload-module module-bluetooth-policy\nload-module module-bluetooth-discover" >> /etc/pulse/system.pa \
    && echo "-> [i] All done, try using 'bluetoothctl' to pair and connect to a device." \
    && echo "-> [i] To automatically power on bluetooth at boot add 'AutoEnable=true' to the last line in '/etc/bluetooth/main.conf'" \
    && echo "-> [i] If there are errors when trying to connect to a device, try installing 'pulseaudio-bluetooth-a2dp-gdm-fix' or checking the wiki." \
    && echo "-> Done." \
    || echo "-> Failed... Check your modules."
