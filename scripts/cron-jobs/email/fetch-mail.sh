#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

config_dir="$HOME/.config/mbsyncrc"
inbox_dir="$HOME/.mail/gmail/Inbox"
temp_file="/tmp/fetch-mail.tmp"
icon_mail="/usr/share/icons/Papirus/32x32/apps/mutt.svg"

if [[ ! -e "$temp_file" ]]; then
    /usr/bin/touch "$temp_file"

    /usr/bin/mbsync -c "$config_dir" -a

    new_mail=$(find "$inbox_dir/new" -type f | wc -l)

    if [[ "$new_mail" -ne 0 ]]; then
        [[ "$new_mail" -eq 1 ]] && /usr/bin/notify-send -i "$icon_mail" "[NeoMutt]" "You have (1) new mail!" || \
            /usr/bin/notify-send -i "$icon_mail" "[NeoMutt]" "You have ($new_mail) new emails!"
    fi

    /usr/bin/rm "$temp_file"
fi

