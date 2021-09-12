#!/usr/bin/env bash
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
youtube_dl_path="/usr/local/bin/youtube-dl"
notify_send_path="/usr/bin/notify-send"

# ICONS
icon_info="/usr/share/icons/Papirus-Dark/32x32/status/dialog-information.svg"
icon_error="/usr/share/icons/Papirus-Dark/32x32/status/dialog-error.svg"

# VIDEO AND PLAYLIST OPTIONS
audio_format="mp3"
output_string="$HOME/Sync/%(title)s.%(ext)s"

## CHECKS ##
# Check if playlists file exists
if ! [[ -e playlists ]]; then
    "$notify_send_path" -i "$icon_error" "[CRON] [download-playlist]" "Failed to find playlists file..."
    exit 1
fi

# Check if the playlists need to be started at a certain point
if [[ -e startat ]]; then
    start_at=$(< startat)
else
    start_at=1
fi

## MAIN ##
"$notify_send_path" -i "$icon_info" "[CRON] [download-playlist]" "Running..."

if "$youtube_dl_path" \
    --download-archive archive \
    -x --audio-format "$audio_format" \
    --playlist-start "$start_at" --dateafter now-3days \
    -o "$output_string" \
    -a playlists;
    then
        "$notify_send_path" -i "$icon_info" "[CRON] [download-playlist]" "Playlist(s) have been downloaded"
    else
        "$notify_send_path" -i "$icon_error" "[CRON] [download-playlist]" "Failed to download playlist(s) or nothing to download was found"
fi
