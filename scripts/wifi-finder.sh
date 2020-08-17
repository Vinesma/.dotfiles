#!/bin/bash
#
# Shows available wifi connections and allows the user to connect to them.
# - Dependencies:
# nmcli, rofi

password-menu() {
    local pass
    pass=$(rofi -dmenu -password -p 'Password' -lines 0)

    echo "$1 - $pass"
}

show-menu() {
    local available
    available=$(nmcli -f BARS,RATE,SSID device wifi list | sed '1d')

    selection=$(echo -e "$available" | rofi -dmenu -only-match -i -p 'Wifi list' -lines 10)
    ssid=$(echo "$selection" | cut -d' ' -f 6-)

    password-menu "$ssid"
}

show-menu
