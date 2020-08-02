#!/bin/bash

## VARS ##
terminal_em="xterm kitty"
window_manager="qtile"
display_manager="lightdm lightdm-gtk-greeter"
file_manager="thunar tumbler ffmpegthumbnailer"
mnt_helper="udiskie"
ibrowser="firefox"

## CONFIG DIRS ##
# mcf = main config dir
# dcf = .dotfiles config dir
mcf_dotfiles="$HOME/"
dcf_dotfiles="$HOME/.dotfiles"
mcf_term="$HOME/.config/kitty"
dcf_term="$HOME/.dotfiles/kitty/*"
mcf_wm="$HOME/.config/qtile"
dcf_wm="$HOME/.dotfiles/qtile/*"
mcf_dunst="$HOME/.config/dunst"
dcf_dunst="$HOME/.dotfiles/dunst/*"
mcf_nano="$HOME/.config/nano"
dcf_nano="$HOME/.dotfiles/nano/*"

echo -e "==> Initializing install...\n"

## XINIT ##
echo "==> Installing xorg server and xinit"
sudo pacman -Syu xorg-server xorg-xinit
echo

## USER DIRECTORIES ##
echo "==> Creating user dirs..."
sudo pacman -S xdg-user-dirs \
    && xdg-user-dirs-update
echo

## BASHRC AND INIT FILES ##
echo "-> Copying .bashrc..."
cp "$dcf_dotfiles"/.bashrc "$mcf_dotfiles"
echo "-> Copying x init files..."
cp "$dcf_dotfiles"/.xinitrc "$mcf_dotfiles"
echo "-> Initializing xprofile file..."
touch "$HOME"/.xprofile
echo -e "[i] The .xprofile file can be used to autostart programs like so:\nredshift-gtk &\nsleep 10 && syncthing --no-browser &\n"

## TERMINAL & EDITOR ##
echo "==> Installing terminal emulator"
sudo pacman -S $terminal_em \
    && mkdir -p "$mcf_term"/ \
    && echo "Directory: $mcf_term created" \
    && cp "$dcf_term" "$mcf_term"/ \
    && echo "[terminal] Config files copied over"

echo "Configuring nano..."
    mkdir -p "$mcf_nano"/ \
    && echo "Directory: $mcf_nano created" \
    && cp "$dcf_nano" "$mcf_nano"/ \
    && echo -e "[nano] Config files copied over\n"

## WINDOW MANAGER ##
echo "==> Installing WM"
sudo pacman -S $window_manager \
    && mkdir -p "$mcf_wm"/ \
    && echo "Directory: $mcf_wm created" \
    && cp /usr/share/doc/qtile/default_config.py "$mcf_wm"/config.py \
    && echo "[window manager] Default config files copied over\n"

## MANJARO SETTINGS MANAGER ##
echo "==> Installing settings manager"
sudo pacman -S manjaro-settings-manager
echo

## FILE MANAGER ##
echo "==> Installing file manager"
sudo pacman -S $file_manager
echo

## MOUNT HELPER ##
echo "==> Installing mount helper"
sudo pacman -S $mnt_helper \
    && echo "-> Enabling mount helper autostart..." \
    && echo "udiskie &" >> "$HOME"/.xprofile
echo

## AUDIO ##
echo "==> Configuring audio..."
sudo pacman -S alsa-utils alsa-plugins
amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute
echo -e "[i] You can use alsamixer to change the volume\n[i] pulsemixer as well"
sudo pacman -S pulseaudio pulseaudio-alsa pulsemixer
echo

## NOTIFICATIONS ##
echo "==> Configuring notifications..."
sudo pacman -S dunst \
    && mkdir -p "$mcf_dunst"/ \
    && echo "Directory: $mcf_dunst created" \
    && cp "$dcf_dunst" "$mcf_dunst"/ \
    && echo -e "[dunst] Config files copied over\n[dunst] Remember to configure DBUS later\n"

## WEB BROWSER ##
echo "==> Installing browser"
sudo pacman -S $ibrowser
echo

## DISPLAY MANAGER ##
echo "==> Installing a display manager"
sudo pacman -S $display_manager
echo -e "[i] Make sure to later enable lightdm.service\n"

echo "-> All done! Enjoy the weeks of work that went into this!"
echo "[i] Make sure to review any errors that may have occured during the process."
echo "[i] Now, give the system a restart and install the optional packages."
