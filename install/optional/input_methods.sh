#!/bin/bash

iengine="fcitx fcitx-mozc fcitx-configtool"

echo "==> Installing fcitx with mozc module"
sudo pacman -Syu $iengine \
    && echo "fcitx &" >> "$HOME"/.xprofile \
    && echo "-> [i] Run these commands to configure the language engine:" \
    && echo "-> [i] $ fcitx" \
    && echo "-> [i] $ fcitx-configtool" \
    && echo "-> [i] Then restart the program (right click on systray icon) to solidify changes." \
    && echo "-> Done." \
    || echo "-> Failed..."
