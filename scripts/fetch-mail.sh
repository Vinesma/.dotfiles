#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

config_dir="$HOME/.config/mbsyncrc"
inbox_dir="$HOME/.mail/gmail/Inbox"
icon_mail="/usr/share/icons/Papirus/32x32/apps/mutt.svg"

/usr/bin/mbsync -c "$config_dir" -a

new_mail=$(find "$inbox_dir/new" -type f | wc -l)

if [[ "$new_mail" -ne 0 ]]; then
    [[ "$new_mail" -eq 1 ]] && /usr/bin/notify-send -i "$icon_mail" "[Mail]" "You have (1) new mail!" || \
        /usr/bin/notify-send -i "$icon_mail" "[Mail]" "You have ($new_mail) new emails!"
fi

# DEBUG
# /usr/bin/notify-send -i "$icon_mail" "[Mail]" "Mail Synced!"
