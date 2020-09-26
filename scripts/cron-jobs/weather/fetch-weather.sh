#!/bin/bash
#
# Shows a notification with information about weather conditions in the specified location.
# Features:
# - DATA: Temperature and current weather condition.
#

# Exports so that the notification can be sent and seen.
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

folder="$HOME/.dotfiles/scripts/cron-jobs/weather"
icon="/usr/share/icons/Papirus/32x32/apps/weather.svg"
curl_dir="/usr/bin/curl"
site="wttr.in"
format="%l:+%c+%t\nRain:+%p"

if [[ ! -e "$folder/running.tmp" ]]; then
    /usr/bin/touch "$folder/running.tmp"

    if [[ -e "$folder/city.tmp" ]]; then
        city=$(< "$folder/city.tmp")

        if response=$($curl_dir -s "$site"/"$city"?format="$format"); then
            /usr/bin/notify-send -i "$icon" "[Weather report]" "$response"
        fi
    else
        /usr/bin/notify-send -i "$icon" "[Weather report]" "Add a file called city.tmp with the location you want to the folder this script is in to configure it."
    fi

    /usr/bin/rm "$folder/running.tmp"
fi
