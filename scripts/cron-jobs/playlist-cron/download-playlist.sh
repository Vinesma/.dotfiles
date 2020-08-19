#!/bin/bash
#
# This script is meant to run via CRON
# Features:
# - PLAYLISTS: Download playlists at a set time, great for podcasts.
# Dependencies
# - youtube-dl

# Exports so that the notification can be sent and seen.
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

# PATHS
cat_path="/usr/bin/cat"
youtube_dl_path="/usr/local/bin/youtube-dl"
date_path="/usr/bin/date"
notify_send_path="/usr/bin/notify-send"

# ICONS
icon_info="/usr/share/icons/Papirus-Dark/32x32/status/dialog-information.svg"
icon_error="/usr/share/icons/Papirus-Dark/32x32/status/dialog-error.svg"

# VIDEO AND PLAYLIST OPTIONS
audio_format="mp3"
output_string="$HOME/Podcasts/Phone/%(title)s.%(ext)s"

## CHECKS ##
# Check if playlists file exists
if ! [[ -e playlists ]]; then
    "$notify_send_path" -i "$icon_error" "[CRON] [download-playlist]" "Failed to find playlists file..."
    exit 1
fi

# Check if the program has been run before (last_date exists)
if [[ -e last_date ]]; then
    date=$("$cat_path" last_date)
else
    date=20200101
fi

# Check if the playlists need to be started at a certain point
if [[ -e startat ]]; then
    start_at=$("$cat_path" startat)
else
    start_at=1
fi

## MAIN ##
"$notify_send_path" -i "$icon_info" "[CRON] [download-playlist]" "Running..."

if "$youtube_dl_path" \
    --download-archive archive \
    -x --audio-format "$audio_format" \
    --playlist-start "$start_at" --dateafter "$date" \
    -o "$output_string" \
    -a playlists;
    then
        "$notify_send_path" -i "$icon_info" "[CRON] [download-playlist]" "Playlist(s) have been downloaded"
        "$date_path" +%Y%m%d > last_date
    else
        "$notify_send_path" -i "$icon_error" "[CRON] [download-playlist]" "Failed to download playlist(s) or nothing to download was found"
fi
