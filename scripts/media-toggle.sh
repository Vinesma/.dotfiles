#!/bin/bash
#
# Toggle mpv + mpd playback
#

mpv_socket="/tmp/mpvsocket"

mpc toggle

if [[ -e "$mpv_socket" ]]; then
    echo 'cycle pause' | socat - "$mpv_socket"
fi