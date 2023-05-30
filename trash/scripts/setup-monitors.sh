#!/usr/bin/env bash
#
# Use this script to setup monitors if X11 refuses to cooperate
#

default_monitors="2"

# Check if all monitors are detected
has-all-monitors() {
    xrandr --listmonitors | head -n 1 | cut -d ' ' -f2 | grep "$1"
    return
}

preferred-monitors() {
    xrandr --output HDMI-2 --auto --primary --output eDP-1 --auto --left-of HDMI-2
}

fallback-monitors() {
    xrandr --output eDP-1 --auto --primary
}

if has-all-monitors "$default_monitors"; then
    preferred-monitors
else
    fallback-monitors
fi
