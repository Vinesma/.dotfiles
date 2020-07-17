#!/bin/bash
# CRON SCRIPT
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

# GLOBALS
home_path="/home/vinesma"
cat_path="/usr/bin/cat"
youtube_dl_path="/usr/local/bin/youtube-dl"
date_path="/usr/bin/date"
notify_send_path="/usr/bin/notify-send"
icon_info="/usr/share/icons/Papirus-Dark/32x32/status/dialog-information.svg"
icon_error="/usr/share/icons/Papirus-Dark/32x32/status/dialog-error.svg"

# VIDEO AND PLAYLIST OPTIONS
playlist="https://www.youtube.com/playlist?list=PLJwv6sN_mnF0QsOTcKlFDeyzwXMM0MWru"
start_at="143"
audio_format="mp3"
output_string="$home_path/Sync/%(title)s.%(ext)s"

date=$("$cat_path" lastDate)

if ! "$youtube_dl_path" --download-archive archive.txt \
        -x --audio-format "$audio_format" \
        --playlist-start "$start_at" --dateafter "$date" \
        -o "$output_string" "$playlist";
    then
        "$notify_send_path" -i "$icon_info" "CRON" "[download-playlist] Playlist(s) have been downloaded"
    else
        "$notify_send_path" -i "$icon_error" "CRON" "[download-playlist] Failed to download playlist(s) or nothing to download was found"
    fi

"$date_path" +%Y%m%d > lastDate
