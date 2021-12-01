#!/usr/bin/env bash
#
# Shows available wifi connections and allows the user to connect to them.
# - Dependencies:
# nmcli, rofi

icon_connected="/usr/share/icons/Papirus/32x32/status/online.svg"
icon_search="/usr/share/icons/Papirus/32x32/devices/network-wireless.svg"
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

wifi-toggler() {
    local status

    wifi toggle

    status=$(wifi | awk '{print $3}')

    if [[ "$status" = "on" ]]; then
        notify-send -i "$icon_connected" "Wifi" "Online"
    else
        notify-send -i "$icon_failed" "Wifi" "Offline"
    fi
}

show-menu() {
    notify-send -t 1500 -i "$icon_search" "[wifi-finder]" "Searching..."

    local selection
    selection=$(nmcli -f BARS,RATE,SSID device wifi list | sed '1d')

    if [[ -n "$selection" ]]; then
        selection=$(echo -e " Exit\n Toggle Wifi\n$selection" | rofi -dmenu -only-match -i -p 'Wifi list' -lines 10)
        ssid=$(echo "$selection" | cut -d' ' -f 6- | sed 's/\s\+$//g')

        case "$selection" in
            " Exit") exit ;;
            " Toggle Wifi") wifi-toggler ;;
            *) password-menu "$ssid" ;;
        esac
    else
        selection=$(echo -e " Exit\n Toggle Wifi" | rofi -dmenu -only-match -i -p 'Wifi list' -lines 3 -mesg 'No networks found, or wifi is offline.')

        case "$selection" in
            " Toggle Wifi") wifi-toggler ;;
            *) exit ;;
        esac
    fi
}

show-menu
