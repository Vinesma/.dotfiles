#!/usr/bin/env bash
#
# Setup bluez, a bluetooth manager.

# -- ACT --
sudo systemctl enable --now bluetooth
printf '%s\n%s' \
    'load-module module-bluetooth-policy' \
    'load-module module-bluetooth-discover' \
    | sudo tee -a /etc/pulse/system.pa