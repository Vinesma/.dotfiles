#!/bin/bash
#
# Shows available wifi connections and allows the user to connect to them.
# - Dependencies:
# nmcli, rofi

password-menu() {
    local pass
    pass=$(rofi -dmenu -password -p 'Password' -lines 0)

    if nmcli device wifi connect "$1" password "$pass"; then
        notify-send "Wi-fi" "Now connected to '$1'"
    else
        notify-send "Wi-fi" "Connection failed..."
    fi
}

show-menu() {
    local selection
    selection=$(nmcli -f BARS,RATE,SSID device wifi list | sed '1d')

    selection=$(echo -e "$available" | rofi -dmenu -only-match -i -p 'Wifi list' -lines 10)
    ssid=$(echo "$selection" | cut -d' ' -f 6- | sed 's/\s\+$//g')

    password-menu "$ssid"
}

show-menu
