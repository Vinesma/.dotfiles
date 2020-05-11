#!/bin/sh

# VARS
key_map="br"
terminal_em="xterm kitty"
window_manager="qtile"
display_manager="lightdm lightdm-gtk-greeter"
file_manager="thunar tumbler ffmpegthumbnailer"
mnt_helper="udiskie"
ibrowser="firefox"

# CONFIG DIRS
# mcf = main config dir
# dcf = .dotfiles config dir
mcf_dotfiles="$HOME/"
dcf_dotfiles="$HOME/.dotfiles"
mcf_term="$HOME/.config/kitty/"
dcf_term="$HOME/.dotfiles/kitty/*"
mcf_wm="$HOME/.config/qtile/"
dcf_wm="$HOME/.dotfiles/qtile/*"
mcf_dunst="$HOME/.config/dunst/"
dcf_dunst="$HOME/.dotfiles/dunst/*"

echo "Initializing install..."
echo

echo "- Installing xinit"
sudo pacman -Syu xorg-xinit
echo

echo "- Creating user dirs..."
sudo pacman -S xdg-user-dirs
xdg-user-dirs-update
echo

echo "- Copying .bashrc..."
cp $dcf_dotfiles/.bashrc $mcf_dotfiles
echo "- Copying x init files..."
cp $dcf_dotfiles/.xinitrc $mcf_dotfiles
cp $dcf_dotfiles/.xprofile $mcf_dotfiles
echo

echo "- Installing terminal emulator"
sudo pacman -S $terminal_em
mkdir -p $mcf_term
echo "Directory: $mcf_term created"
cp $dcf_term $mcf_term
echo "Terminal config files copied over"
echo

echo "- Installing WM"
sudo pacman -S $window_manager
mkdir -p $mcf_wm
echo "Directory: $mcf_wm created"
cp $dcf_wm $mcf_wm
echo "WM config files copied over"
echo

echo "- Installing settings manager"
sudo pacman -S manjaro-settings-manager
echo

echo "- Installing file manager"
sudo pacman -S $file_manager
echo

echo "- Installing mount helper"
sudo pacman -S $mnt_helper
echo

echo "- Configuring audio..."
sudo pacman -S alsa-utils alsa-plugins
amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute
echo -e "You can use alsamixer to change the volume\npulsemixer as well"
sudo pacman -S pulseaudio pulseaudio-alsa pulsemixer
echo

echo "- Configuring notifications..."
sudo pacman -S dunst
mkdir -p $mcf_dunst
echo "Directory: $mcf_dunst created"
cp $dcf_dunst $mcf_dunst
echo "Config files copied over"
echo

echo "- Installing browser"
sudo pacman -S $ibrowser
echo

echo "- Installing a display manager"
sudo pacman -S $display_manager
echo "Make sure to later enable the: lightdm.service"
echo

echo "All done! Enjoy the days of work that went into this!"
echo "Give the system a restart, or install the optional packages."
