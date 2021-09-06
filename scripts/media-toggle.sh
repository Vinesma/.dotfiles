#!/bin/bash
#
# Toggle mpv + mpd playback
#

mpv_socket="/tmp/mpvsocket"

# try toggling mpv, if it doesn't work, toggle mpc instead
# this gives mpv priority when command could apply to both
if ! echo 'cycle pause' | socat - "$mpv_socket"; then
    mpc toggle
fi
