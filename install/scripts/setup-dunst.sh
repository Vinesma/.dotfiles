#!/usr/bin/env bash
#
# Setup the notification daemon

# -- ACT --
printf '%s\n%s\n%s' \
'[D-BUS Service]' \
'Name=org.freedesktop.Notifications' \
'Exec=/usr/bin/dunst' | sudo tee /usr/share/dbus-1/services/org.freedesktop.Notifications.service > /dev/null