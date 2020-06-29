#!/bin/bash

curl_dir="/usr/bin/curl"
site="wttr.in"
city="-9.3817334,-40.4968875"
format="+%c+%t"

echo $($curl_dir -s "$site"/"$city"?format="$format" || echo "")
