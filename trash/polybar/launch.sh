#!/usr/bin/env bash

# Main config path
CONFIG_FILE=$HOME/.dotfiles/polybar/config.ini

# Terminate already running bar instances
killall -q polybar

while IFS= read -r monitor; do
    m=$(printf "%s" "$monitor" | cut -d : -f1)
    temp_file=/tmp/polybar.$m.tmp

    if printf "%s" "$monitor" | grep -q "primary"; then
        printf "%s\n" "--- LAUNCH main ON $m ---" | tee -a "$temp_file"
        MONITOR=$m polybar main -c "$CONFIG_FILE" 2>&1 | tee -a "$temp_file" & disown
    else
        printf "%s\n" "--- LAUNCH minimal ON $m ---" | tee -a "$temp_file"
        MONITOR=$m polybar minimal -c "$CONFIG_FILE" 2>&1 | tee -a "$temp_file" & disown
    fi
done <<< "$(polybar --list-monitors)"

printf "%s\n" "[Polybar]: Bars launched..."
