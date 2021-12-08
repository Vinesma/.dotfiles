#!/usr/bin/env bash
#
# Setup bluez, a bluetooth manager.

# -- ACT --
sudo systemctl enable --now bluetooth
sudo sed -i -e '$a\load-module module-bluetooth-policy' /etc/pulse/system.pa
sudo sed -i -e '$a\load-module module-bluetooth-discover' /etc/pulse/system.pa