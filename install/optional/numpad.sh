#!/bin/bash

numpad="numlockx"

echo "==> Installing numpad helper"
sudo pacman -Syu $numpad \
    && echo "numlockx &" >> "$HOME"/.xprofile \
    && echo "-> Done" \
    || echo "-> Failed..."
