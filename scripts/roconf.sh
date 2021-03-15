#!/usr/bin/bash
#
# Script name: roconf
# Description: Choose from a list of configuration files to edit.
# Dependencies: rofi
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor
# Modified by: Vinesma (Otavio Cornelio da Silva)

# Defining the text editor to use.
# DMEDITOR="st -e vim"
# DMEDITOR="emacsclient -c -a emacs"
DMEDITOR="kitty nvim"

# An array of options to choose.
# You can edit this list to add/remove config files.
declare -a options=(
"alacritty - $HOME/.config/alacritty/alacritty.yml"
"awesome - $HOME/.config/awesome/rc.lua"
"bash - $HOME/.bashrc"
"broot - $HOME/.config/broot/conf.toml"
"bspwm - $HOME/.config/bspwm/bspwmrc"
"doom emacs config.el - $HOME/.doom.d/config.el"
"doom emacs init.el - $HOME/.doom.d/init.el"
"doom emacs packages.el - $HOME/.doom.d/packages.el"
"dunst - $HOME/.config/dunst/dunstrc"
"dwm - $HOME/dwm-distrotube/config.def.h"
"dwmblocks - $HOME/dwmblocks-distrotube/blocks.def.h"
"fish - $HOME/.config/fish/config.fish"
"herbstluftwm - $HOME/.config/herbstluftwm/autostart"
"i3 - $HOME/.i3/config"
"neovim - $HOME/.config/nvim/init.vim"
"picom - $HOME/.config/picom/picom.conf"
"polybar - $HOME/.config/polybar/config"
"qtile - $HOME/.config/qtile/config.py"
"quickmarks - $HOME/.config/qutebrowser/quickmarks"
"qutebrowser - $HOME/.config/qutebrowser/autoconfig.yml"
"spectrwm - $HOME/.spectrwm.conf"
"st - $HOME/st-distrotube/config.def.h"
"stumpwm - $HOME/.config/stumpwm/config"
"surf - $HOME/surf-distrotube/config.def.h"
"sxhkd - $HOME/.config/sxhkd/sxhkdrc"
"tabbed - $HOME/tabbed-distrotube/config.def.h"
"termite - $HOME/.config/termite/config"
"vifm - $HOME/.config/vifm/vifmrc"
"vim - $HOME/.vimrc"
"xmobar mon1  - $HOME/.config/xmobar/xmobarrc0"
"xmobar mon2 - $HOME/.config/xmobar/xmobarrc1"
"xmobar mon3 - $HOME/.config/xmobar/xmobarrc2"
"xmonad - $HOME/.xmonad/README.org"
"xresources - $HOME/.Xresources"
"zsh - $HOME/.zshrc"
"quit"
)

# Piping the above array into rofi.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -lines 20 -p 'Edit config:')

# What to do when/if we choose 'quit'.
if [[ "$choice" == "quit" ]]; then
    echo "Program terminated." && exit 0

# What to do when/if we choose a file to edit.
elif [ "$choice" ]; then
	cfg=$(printf '%s\n' "${choice}" | awk '{print $NF}')
	$DMEDITOR "$cfg"

# What to do if we just escape without choosing anything.
else
    echo "Program terminated." && exit 0
fi
