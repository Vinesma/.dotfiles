#!/usr/bin/env bash
#
# Setup qt5ct

# -- ACT --
printf '%s' 'QT_QPA_PLATFORMTHEME=qt5ct' | sudo tee -a /etc/environment