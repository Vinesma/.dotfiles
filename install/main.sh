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
dmcf_nvim="$HOME/.config/nvim"
dcf_nvim="$HOME/.dotfiles/nvim/*"

echo -e "==> Initializing install...\n"

## XINIT ##
echo "==> Installing xorg server and xinit"
sudo pacman -Syu xorg-server xorg-xinit
echo "-> Done."

## USER DIRECTORIES ##
echo "==> Creating user dirs..."
sudo pacman -S xdg-user-dirs \
    && xdg-user-dirs-update \
    && echo "-> Done."

## BASHRC AND INIT FILES ##
echo "-> Copying .bashrc..."
cp -v "$dcf_dotfiles"/.bashrc "$mcf_dotfiles"
echo "-> Copying x init files..."
cp -v "$dcf_dotfiles"/.xinitrc "$mcf_dotfiles"
echo "-> Initializing autostart file..."
echo '#!/bin/bash' > "$HOME"/.autostart
echo -e "-> [i] The autostart file can be used to start programs like so:\nredshift-gtk &\nsleep 10 && syncthing --no-browser &\n"
echo -e "-> [i] An example autostart file is included in '/.dotfiles/install/'"

## TERMINAL & EDITORS ##
echo "==> Installing terminal emulator"
sudo pacman -S $terminal_em \
    && mkdir -pv "$mcf_term"/ \
    && cp -v "$dcf_term" "$mcf_term"/ \
    && echo "[terminal] Config files copied over" \
    && echo "-> Done."

echo "==> Installing neovim"
sudo pacman -S neovim\
    && mkdir -pv "$mcf_nvim"/ \
    && cp -v "$dcf_nvim" "$mcf_nvim"/ \
    && echo "[nvim] Config files copied over" \
    && echo "-> Done."

echo "Configuring nano..."
    mkdir -pv "$mcf_nano"/ \
    && cp -v "$dcf_nano" "$mcf_nano"/ \
    && echo "[nano] Config files copied over" \
    && echo "-> Done."

## WINDOW MANAGER ##
echo "==> Installing WM"
sudo pacman -S $window_manager \
    && mkdir -pv "$mcf_wm"/ \
    && cp -v /usr/share/doc/qtile/default_config.py "$mcf_wm"/config.py \
    && echo "[window manager] Default config files copied over\n" \
    && echo "-> Done."

## MANJARO SETTINGS MANAGER ##
# echo "==> Installing settings manager"
# sudo pacman -S manjaro-settings-manager
# echo

## FILE MANAGER ##
echo "==> Installing file manager"
sudo pacman -S $file_manager
echo

## MOUNT HELPER ##
echo "==> Installing mount helper"
sudo pacman -S $mnt_helper \
    && echo "-> Enabling mount helper autostart..." \
    && echo "udiskie &" >> "$HOME"/.autostart \
    && echo "-> Done."

## AUDIO ##
echo "==> Configuring audio..."
sudo pacman -S alsa-utils alsa-plugins
amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute
echo "-> [i] You can use alsamixer or pulsemixer to change the volume"
sudo pacman -S pulseaudio pulseaudio-alsa pulsemixer
echo

## NOTIFICATIONS ##
echo "==> Configuring notifications..."
sudo pacman -S dunst \
    && mkdir -pv "$mcf_dunst"/ \
    && cp -v "$dcf_dunst" "$mcf_dunst"/ \
    && echo "[dunst] Config files copied over" \
    && echo "-> Configuring DBUS..." \
    && sudo cp -v "$HOME/.dotfiles/install/org.freedesktop.Notifications.service" "/usr/share/dbus-1/services/" \
    && echo "dunst &" >> "$HOME"/.autostart \
    && echo "-> Done."

## WEB BROWSER ##
echo "==> Installing browser"
sudo pacman -S $ibrowser
echo

## DISPLAY MANAGER ##
echo "==> Installing a display manager"
sudo pacman -S $display_manager
echo -e "-> [i] Make sure to later enable lightdm.service\n"

echo "-> All done! Enjoy the weeks of work that went into this!"
echo "-> [i] Make sure to review any errors that may have occured during the process."
echo "-> [i] Now, give the system a restart and install the optional packages."
