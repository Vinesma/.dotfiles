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
temperature=$(echo "$response"   | cut -d' ' -f -3 | cut -d' ' -f 2)
precipitation=$(echo "$response" | cut -d' ' -f -3 | cut -d' ' -f 3)

# 0.0mm precipitation is not shown
print_weather() {
    [[ "$precipitation" == "0.0mm" ]] \
        && echo "$1 $temperature" \
        || echo "$1 $temperature $precipitation"
}

assign_icon() {
    case "$response" in
        *Partly\ cloudy*|*Overcast*) print_weather "杖" ;;
        *Light\ rain*) print_weather "殺" ;;
        *Cloudy*) print_weather "摒" ;;
        *Clear*|*Sunny*) print_weather "滛" ;;
        *) echo "$response" ;;
    esac
}

echo "$response" | grep -q "°C" && assign_icon || echo ""
