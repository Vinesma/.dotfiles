#!/bin/bash

curl_dir="/usr/bin/curl"
site="wttr.in"
city="Petrolina"
format="+%t+%p+%C"

response=$($curl_dir -s "$site"/"$city"?format="$format")

assign_icon() {
	local weather_info=$(echo "$response" | cut -d' ' -f -3)
	case "$response" in
		*Partly\ cloudy*) echo "杖$weather_info" ;;
		*Light\ rain*) echo "殺$weather_info" ;;
		*Clear*|*Sunny*) echo "滛$weather_info" ;;
		*) echo "$response" ;;
	esac
}

echo "$response" | grep -q "°C" && assign_icon || echo ""
