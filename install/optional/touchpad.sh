#!/bin/sh

touchpd="xorg-xinput"

echo "- Installing touchpad tools"
sudo pacman -Syu "$touchpd"
echo
echo "[1] Usage: xinput list -> Grab the device id you want to change"
echo "[2] xinput list-props [id] -> List what can be changed"
echo "[3] xinput set-prop [id] [prop-id] [1/0] -> non-persistent"
echo "You can add the command to .xprofile to make it persistent, beware if the device changes id."

echo "Done."
