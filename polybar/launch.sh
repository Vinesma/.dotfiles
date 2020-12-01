#!/bin/bash

config_path="$HOME/.cache/wal/colors-main-polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
polybar -c "$config_path" main &

echo -e "Polybar launched...\n\t-> Config: $config_path"
