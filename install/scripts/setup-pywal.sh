#!/usr/bin/env bash
#
# Init a base color scheme and setup pywal's templates

MY_TEMPLATES_DIR=$HOME/.dotfiles/pywal-templates
WAL_TEMPLATES_DIR=$HOME/.config/wal/templates
DEFAULT_WALLPAPER=$HOME/.dotfiles/files/wallpaper_default.png

# -- SETUP --
mkdir -p "$WAL_TEMPLATES_DIR"

# -- ACT --
## Create links for
# Dunst config
ln -sfv "$MY_TEMPLATES_DIR/colors-dunst" "$WAL_TEMPLATES_DIR"

# Polybar colors
ln -sfv "$MY_TEMPLATES_DIR/colors-polybar.ini" "$WAL_TEMPLATES_DIR"

# Zathura colors
ln -sfv "$MY_TEMPLATES_DIR/colors-zathura" "$WAL_TEMPLATES_DIR"

# Gtk colors
ln -sfv "$MY_TEMPLATES_DIR/gtk.css" "$WAL_TEMPLATES_DIR"

# Jellyfin colors
ln -sfv "$MY_TEMPLATES_DIR/colors-jellyfin.css" "$WAL_TEMPLATES_DIR"

# Rofi themes
ln -sfv "$MY_TEMPLATES_DIR/colors-rofi-launcher.rasi" "$WAL_TEMPLATES_DIR"
ln -sfv "$MY_TEMPLATES_DIR/colors-rofi-powermenu.rasi" "$WAL_TEMPLATES_DIR"

# Create default color scheme
wal -e -t -s -n -i "$DEFAULT_WALLPAPER"

# Link generated dunst config file to the proper place
mkdir -p "$HOME/.config/dunst"
ln -sfv "$HOME/.cache/wal/colors-dunst" "$HOME/.config/dunst/dunstrc"

# Link generated gtk colors file
mkdir -p "$HOME/.config/gtk-3.0"
ln -sfv "$HOME/.cache/wal/gtk.css" "$HOME/.config/gtk-3.0"