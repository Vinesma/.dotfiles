#!/bin/sh

backlight_util="xorg-xbacklight"

echo "- Installing backlight utility"
sudo pacman -Syu $backlight_util
echo

echo "[sudo] Usage: xbacklight -set 50"

echo "Done."
