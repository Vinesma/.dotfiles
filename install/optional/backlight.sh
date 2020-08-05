#!/bin/bash

backlight_util="xorg-xbacklight"

echo "==> Installing backlight utility"
sudo pacman -Syu $backlight_util \
    && echo "-> [i] $ xbacklight -set 12" \
    && echo "-> Done." \
    || echo "-> Failed..."
