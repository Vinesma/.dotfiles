#!/bin/bash

icon="/usr/share/icons/Papirus/32x32/apps/mpd.svg"

mpc crop
mpc repeat off

notify-send -i "$icon" "MPD" "Queue cleared!"


