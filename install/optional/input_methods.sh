#!/bin/bash

iengine="fcitx fcitx-mozc fcitx-configtool"

echo "==> Installing fcitx with mozc module"
sudo pacman -Syu $iengine \
    && echo "fcitx &" >> "$HOME"/.xprofile \
    && echo "[i] Run fcitx then fcitx-configtool to configure, then reboot to solidify changes" \
    && echo "-> Done." \
    || echo "-> Failed..."
