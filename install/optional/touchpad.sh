#!/bin/bash

touchpd="xorg-xinput"

echo "==> Installing touchpad tools."
sudo pacman -Syu $touchpd \
    && echo -e "\n[i-1] Usage: xinput list -> Grab the device id you want to change" \
    && echo      "[i-2] xinput list-props [id] -> List what can be changed" \
    && echo      "[i-3] xinput set-prop [id] [prop-id] [1/0] -> non-persistent" \
    && echo      "[i] You can add the command to .xprofile to make it persistent, beware if the device changes id after kernel changes." \
    && echo "-> Done." \
    || echo "-> Failed..."
