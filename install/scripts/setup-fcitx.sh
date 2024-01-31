#!/usr/bin/env bash
#
# Setup input methods

# -- ACT --
printf '\n%s' \
    'QT_IM_MODULE=fcitx' \
    'XMODIFIERS=@im=fcitx' \
    'GLFW_IM_MODULE=ibus' | sudo tee -a /etc/environment > /dev/null
