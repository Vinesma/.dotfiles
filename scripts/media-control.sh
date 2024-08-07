#!/usr/bin/env bash
#
# Control mpv + mpd playback. If commands would apply to both, mpv gets priority.
# TODO: See if MPRIS can replace this
#

mpv_socket="/tmp/mpvsocket"
audio_icon="/usr/share/icons/Papirus/32x32/devices/audio-speakers.svg"
notify_time="800"

mpv-command() {
    if [[ -e "$mpv_socket" ]]; then
        echo "$1" | socat - "$mpv_socket"
        return
    else
        return 1
    fi
}

toggle_media() {
    if ! mpv-command 'cycle pause'; then
        mpc -q toggle
    fi
}

set-volume() {
    if ! mpv-command "add volume $1"; then
        mpc -q volume "$1"

        message=$(mpc volume)

        notify-send -r 96069 -i "$audio_icon" -t "$notify_time" "MPD" "${message/:1/: 1}"
    fi
}

seek-by-value() {
    if ! mpv-command "seek $1"; then
        mpc -q seek "$1"
    fi
}

jump-to() {
    if ! mpv-command "playlist-$1"; then
        if [ "$1" == "prev" ]; then
            time=$(mpc status '%currenttime%')
            min=${time%%:*}
            sec=${time##*:}

            [ "$min" -eq 0 ] && [ "$sec" -le 5 ] \
                && mpc -q prev \
                && return

            mpc -q seek 0%
        else
            mpc -q next
        fi
    fi
}

case $1 in
    toggle) toggle_media        ;;
    +*|-*)  set-volume "$1"     ;;
    seek)   seek-by-value "$2"  ;;
    jump)   jump-to "$2"        ;;
    *) printf "%s\n" "Invalid args" ;;
esac
