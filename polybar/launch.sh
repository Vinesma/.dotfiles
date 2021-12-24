#!/usr/bin/env bash

# Main config path
CONFIG_FILE=$HOME/.dotfiles/polybar/config.ini

# List of bar names
declare -a BARS=(
    "main"
)

# Terminate already running bar instances
killall -q polybar

for i in "${!BARS[@]}"; do
    temp_file=/tmp/polybar.${BARS[i]}

    printf "%s\n" "--- LAUNCH ${BARS[i]} ---" | tee -a "$temp_file"
    polybar "${BARS[i]}" -c "$CONFIG_FILE" 2>&1 | tee -a "$temp_file" & disown
done

printf "%s\n" "[Polybar]: Bars launched..."