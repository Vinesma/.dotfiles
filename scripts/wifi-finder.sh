#!/bin/bash
#
# Shows available wifi connections and allows the user to connect to them.
# - Dependencies:
# nmcli, rofi

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_connected="/usr/share/icons/Papirus/32x32/status/online.svg"
icon_failed="/usr/share/icons/Papirus/32x32/status/offline.svg"

password-menu() {
    local pass
    pass=$(rofi -dmenu -password -p 'Password' -lines 0)

    if nmcli device wifi connect "$1" password "$pass"; then
        notify-send -i "$icon_connected" "Wifi-finder" "Now connected to '$1'."
    else
        notify-send -i "$icon_failed" "Wifi-finder" "Connection failed..."
    fi
}

show-menu() {
    local selection
    selection=$(nmcli -f BARS,RATE,SSID device wifi list | sed '1d')

    if [[ -n "$selection" ]]; then
        selection=$(echo -e " Exit\n$selection" | rofi -dmenu -only-match -i -p 'Wifi list' -lines 10)
        ssid=$(echo "$selection" | cut -d' ' -f 6- | sed 's/\s\+$//g')

        if [[ "$selection" != " Exit" ]]; then
            password-menu "$ssid"
        fi
    else
        notify-send -i "$icon_error" "Wifi-finder" "Not near any wifi networks, or no wifi device found."
    fi
}

show-menu
