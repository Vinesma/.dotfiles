#!/bin/bash
#
# Control mpv + mpd playback. If commands would apply to both, mpv gets priority.
#

mpv_socket="/tmp/mpvsocket"
audio_icon="/usr/share/icons/Papirus/32x32/devices/audio-speakers.svg"
notify_time="800"

toggle_media() {
    if ! echo 'cycle pause' | socat - "$mpv_socket"; then
        mpc toggle
    fi
}

set-volume() {
    if ! echo "add volume $1" | socat - "$mpv_socket"; then
        mpc volume "$1"

        message=$(mpc volume)

        notify-send -i "$audio_icon" -t "$notify_time" "MPD" "$message"
    fi
}

seek-by-value() {
    if ! echo "seek $1" | socat - "$mpv_socket"; then
        mpc seek "$1"
    fi
}

case $1 in
    toggle) toggle_media ;;
    +*|-*) set-volume $1 ;;
    seek) seek-by-value $2 ;;
    *) printf 'Invalid args' ;;
esac
