#!/bin/bash

touchpd="xorg-xinput"

echo "==> Installing touchpad tools."
sud pacman -Syu $touchpd \
    && echo -e "\n-> [i] $ xinput list -> Grab the device id you want to change" \
    && echo      "-> [i] $ xinput list-props [id] -> List what can be changed" \
    && echo      "-> [i] $ xinput set-prop [id] [prop-id] [1/0] -> non-persistent" \
    && echo      "-> [i] You can add the command to .autostart to make it persistent, beware if the device changes id after kernel changes." \
    && echo "-> Done." \
    || echo "-> Failed..."
