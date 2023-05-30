#!/usr/bin/env bash
#
# Setup qt5ct

# -- ACT --
printf '\n%s' 'QT_QPA_PLATFORMTHEME=qt5ct' | sudo tee -a /etc/environment > /dev/null