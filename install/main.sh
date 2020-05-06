#!/bin/sh

key_map="br"
terminal_em="xterm kitty"
window_manager="qtile"
display_manager="lightdm"
file_manager="thunar"
mnt_helper="udiskie"

echo "Initializing install..."
echo

echo "Cloning dotfiles"
git clone https://github.com/Vinesma/.dotfiles.git
echo

echo "- Installing xorg and xinit"
sudo pacman -Syu xorg-server xorg-xinit
echo

echo "- Setting keymap..."
localectl --no-convert set-x11-keymap "$key_map"
echo

echo "- Creating user dirs..."
sudo pacman -S xdg-user-dirs
xdg-user-dirs-update
echo

echo "- Installing terminal emulator"
sudo pacman -S "$terminal_em"
echo

echo "- Installing WM"
sudo pacman -S "$window_manager"
echo

echo "- Installing settings manager"
sudo pacman -S manjaro-settings-manager
echo

echo "- Installing file manager"
sudo pacman -S "$file_manager"
echo

echo "- Installing mount helper"
sudo pacman -S "$mnt_helper"
echo

echo "- Configuring audio..."
sudo pacman -S alsa-utils alsa-plugins
amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute
echo "You can use alsamixer to change the volume"
sudo pacman -S pulseaudio pulseaudio-alsa pulsemixer
echo

echo "- Configuring notifications..."
sudo pacman -S dunst
echo

echo "- Installing a display manager"
sudo pacman -S "$display_manager"
echo
echo "Make sure to later enable the: lightdm.service"
echo "Also maybe install a greeter like: lightdm-gtk-greeter"
echo

echo "All done! Enjoy the 5 days of work that went into this!"
