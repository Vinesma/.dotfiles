#!/bin/bash
#
# Script meant to be run by a polybar module, returns weather data with a descriptive icon.
# Features:
# - DATA: Temperature, rainfall and current weather condition.
# - ICONS: Different icons depending on the weather conditions. If unknown, then display the unknown condition so it can be added.
#

curl_dir="/usr/bin/curl"
site="wttr.in"
city="Petrolina"
format="+%t+%p+%C"

response=$($curl_dir -s "$site"/"$city"?format="$format")

assign_icon() {
    local weather_info=$(echo "$response" | cut -d' ' -f -3)
    case "$response" in
        *Partly\ cloudy*|*Overcast*) echo "杖$weather_info" ;;
        *Light\ rain*) echo "殺$weather_info" ;;
        *Cloudy*) echo "摒$weather_info" ;;
        *Clear*|*Sunny*) echo "滛$weather_info" ;;
        *) echo "$response" ;;
    esac
}

echo "$response" | grep -q "°C" && assign_icon || echo ""
