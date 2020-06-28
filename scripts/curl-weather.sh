#!/bin/bash

curl_dir="/usr/bin/curl"
site="wttr.in"
city="Petrolina"
format="+%c+%t"

echo $($curl_dir -s "$site"/"$city"?format="$format" || echo "")
