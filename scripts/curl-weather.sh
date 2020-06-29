#!/bin/bash

curl_dir="/usr/bin/curl"
site="wttr.in"
city="Petrolina"
format="+%c+%t"

response=$($curl_dir -s "$site"/"$city"?format="$format")

echo "$response" | grep "⁰C" && echo "$response" || echo ""
