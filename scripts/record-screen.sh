#!/usr/bin/env bash
#
# Script that records the screen
# Dependencies:
# - ffmpeg

# shellcheck disable=SC2063
resolution=$(xrandr | grep '*' | awk '{printf $1}')
date_string=$(date +%0Y_%0m_%0d-%0l_%0M)
output_name="$date_string screen_record.mp4"
output_dir="$HOME/Videos/"
[ $# -gt 0 ] && frames="$1" || frames="25"

move-file() {
    mv "$output_name" "$output_dir"
}

start-recording() {
    echo -e "\nCapture audio? [y/n]"
    read -r audio_option
    echo "Starting in 5 seconds, press 'q' to stop recording."
    sleep 5s
    echo "Started!"

    case "$audio_option" in
        y|Y) ffmpeg \
               -f x11grab \
               -video_size "$resolution" \
               -framerate "$frames" \
               -i "$DISPLAY" \
               -f pulse \
               -ac 2 \
               -i default \
               -c:v libx264 \
               -preset ultrafast \
               -c:a aac "$output_name" ;;
        *) ffmpeg \
             -f x11grab \
             -video_size "$resolution" \
             -framerate "$frames" \
             -i "$DISPLAY" \
             -c:v libx264 \
             -preset ultrafast \
             -c:a aac "$output_name" ;;
    esac

    move-file
}

echo "Screen recording will start soon, please review the info gathered:"
echo "Screen resolution = $resolution"
echo "Capture framerate = $frames fps (pass an argument to change this)"
echo "Filename = $output_name"
echo -e "\nIs this okay? [y/n]"
read -r option

case "$option" in
    y|Y) start-recording ;;
    *) echo "Exiting..." ;;
esac
