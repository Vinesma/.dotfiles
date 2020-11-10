#!/bin/bash
#
# Auto installer script created by vinesma

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# VARS
count=1
total=$(grep -c 'header-msg-count' "$main_folder/main.sh")
total=$(( "$total" - 1 ))
distribution=$(uname -a)

# Enable or disable DEBUG mode
# This mode can be enabled by passing any argument to the script
if [[ $# -gt 0 ]]; then
    debug=1
    echo -e "RUNNING IN DEBUG MODE"
    # Load helper functions in DEBUG mode
    . "$main_folder/helper-functions.sh" debug
else
    # Load helper functions
    . "$main_folder/helper-functions.sh"
fi

# FUNCTIONS
update-count() {
    count=$(( $count + 1 ))
}

# MAIN
header-msg "Initializing install."
if [[ "$distribution" == *manjaro* ]]; then
    info-msg "Identified: MANJARO LINUX"
    info-msg "Specific packages will be installed"
    distribution=manjaro
else
    info-msg "Failed to identify: MANJARO LINUX"
    info-msg "Specific packages will NOT be installed"
fi

header-msg "Are you installing on a Laptop? (y/n)"
read answer

header-msg "Install printer support? (y/n)"
read answer_printer

## XORG ##
header-msg-count "Installing Xorg"
install-package xorg-server xorg-xinit

## USER DIRECTORIES ##
header-msg-count "Configuring user dirs."
install-package xdg-user-dirs
[[ -z "$debug" ]] && xdg-user-dirs-update && echo "\t-> Done."

## BASHRC ##
header-msg-count "Configuring shell files."
config-by-file "$pack_lists/shell_files"

## AUTOSTART ##
header-msg-count "Initializing autostart file."
[[ -z "$debug" ]] && echo '#!/bin/bash' > "$HOME"/.autostart
info-msg "The autostart file can be used to start programs on startup."
info-msg "An example autostart file is included in '~/.dotfiles/install/files'"
echo "udiskie &" >> "$HOME"/.autostart
echo "dunst &" >> "$HOME"/.autostart

## ESSENTIALS ##
header-msg-count "Installing and configuring essential packages."
config-by-file "$pack_lists/essential"

## WINDOW MANAGER ##
header-msg-count "Installing Window Manager."
config-by-file "$pack_lists/window_manager"

## DISPLAY MANAGER ##
header-msg-count "Enabling display manager."
[[ -z "$debug" ]] && systemctl enable lightdm.service
info-msg "You can use the files in $HOME/.dotfiles/lightdm to quickly configure lightdm"
info-msg "The default config path is /etc/lightdm"

## NOTIFICATIONS ##
header-msg-count "Configuring DBUS notifications."
[[ -z "$debug" ]] && sudo cp -v "$main_folder/files/org.freedesktop.Notifications.service" "/usr/share/dbus-1/services/"

## AUDIO ##
header-msg-count "Configuring audio."
if [[ -z "$debug" ]]; then
    amixer sset Master unmute
    amixer sset Speaker unmute
    amixer sset Headphone unmute
fi
info-msg "You can use alsamixer or pulsemixer to change the volume."

if [[ -z "$debug" ]]; then
    ## OPTIONALS ##

    # KEYMAP
    . "$main_folder/optional/setkeymap.sh"

    # MISC.
    . "$main_folder/optional/appsuite.sh"

    # EYECANDY
    . "$main_folder/optional/eyecandy.sh"

    # APPLETS
    . "$main_folder/optional/applets.sh"

    # INPUT METHODS
    . "$main_folder/optional/input_methods.sh"

    if [[ "$answer_printer" == @(y|Y) ]]; then
        # PRINTER
        . "$main_folder/optional/printers.sh"
    fi

    # MANJARO SPECIFIC
    if [[ "$distribution" = *manjaro* ]]; then
        header-msg "Installing Manjaro settings manager."
        install-package manjaro-settings-manager

        header-msg "Installing Steam (manjaro)"
        install-package steam-manjaro
    fi

    if [[ "$answer" == @(y|Y) ]]; then
        arrow-msg "Installing laptop packages"

        # TOUCHPAD
        . "$main_folder/optional/touchpad.sh"

        # BACKLIGHT
        . "$main_folder/optional/backlight.sh"

        # BLUETOOTH
        . "$main_folder/optional/bluetooth.sh"
    else
        arrow-msg "Installing desktop packages"

        # NUMPAD
        . "$main_folder/optional/numpad.sh"
    fi
fi
