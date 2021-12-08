#!/usr/bin/env bash
#
# Setup qt5ct

# -- ACT --
sudo sed -i -e '$a\QT_QPA_PLATFORMTHEME=qt5ct' /etc/environment