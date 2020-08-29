#!/bin/bash

package_list="$HOME/.dotfiles/install/optional/list_appsuite"

# DIRS
mcf_mpv="$HOME/.config/mpv"
dcf_mpv="$HOME/.dotfiles/mpv/*"
mcf_youtubedl="$HOME/.config/youtube-dl"
dcf_youtubedl="$HOME/.dotfiles/youtube-dl/*"
mcf_newsboat="$HOME/.config/newsboat"
dcf_newsboat="$HOME/.dotfiles/newsboat/*"
mcf_qtile="$HOME/.config/qtile"
dcf_qtile="$HOME/.dotfiles/qtile/*"
mcf_polybar="$HOME/.config/polybar"
dcf_polybar="$HOME/.dotfiles/polybar/*"
mcf_mpd="$HOME/.config/mpd"
dcf_mpd="$HOME/.dotfiles/mpd/*"
mcf_ncmpcpp="$HOME/.config/ncmpcpp"
dcf_ncmpcpp="$HOME/.dotfiles/ncmpcpp/*"
mcf_rofi="$HOME/.config/rofi"
dcf_rofi="$HOME/.dotfiles/rofi/*"

## INSTALL ##
echo "==> Installing suite of apps."
sudo pacman -Syu - < "$package_list"
echo
## MPV ##
echo "-> Configuring mpv..."
    mkdir -pv "$mcf_mpv" \
    && cp -v "$dcf_mpv" "$mcf_mpv"
echo
## YOUTUBE-DL ##
echo "-> Configuring youtube-dl..."
    mkdir -pv "$mcf_youtubedl" \
    && cp -v "$dcf_youtubedl" "$mcf_youtubedl"
echo
## NEWSBOAT ##
echo "-> Configuring newsboat..."
    mkdir -pv "$mcf_newsboat" \
    && cp -v "$dcf_newsboat" "$mcf_newsboat"
echo
## QTILE & POLYBAR ##
echo "-> Copying qtile config over..."
cp -v "$dcf_qtile" "$mcf_qtile"
echo
echo "-> Copying polybar config over..."
    mkdir -pv "$mcf_polybar" \
    && cp -v "$dcf_polybar" "$mcf_polybar" \
    && echo '. $HOME/.config/polybar/launch.sh &' >> "$HOME"/.autostart
echo
## MUSIC PLAYER ##
echo "-> Configuring mpd and auxiliaries..."
    mkdir -pv "$mcf_mpd" \
    && cp -v "$dcf_mpd" "$mcf_mpd" \
    && echo 'if [[ ! -s ~/.config/mpd/pid ]]; then' >> "$HOME"/.autostart \
    && echo "    mpc" >> "$HOME"/.autostart \
    && echo "    mpc random on" >> "$HOME"/.autostart \
    && echo "    mpc repeat on" >> "$HOME"/.autostart \
    && echo "    mpc crossfade 2" >> "$HOME"/.autostart \
    && echo 'fi' >> "$HOME"/.autostart

    mkdir -pv "$mcf_ncmpcpp" \
    && cp -v "$dcf_ncmpcpp" "$mcf_ncmpcpp"
echo
## ROFI ##
echo "-> Configuring rofi..."
    mkdir -pv "$mcf_rofi" \
    && cp -v "$dcf_rofi" "$mcf_rofi"

echo "-> [i] youtube-dl should be installed separately, so that it can be updated quickly via 'youtube-dl -U'"
echo "-> [i] Run these commands when ready to install:"
echo "-> [i] # sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl"
echo "-> [i] # sudo chmod a+rx /usr/local/bin/youtube-dl"
echo "-> Done."
