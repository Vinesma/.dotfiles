#!/usr/bin/env bash

# Main config path
CONFIG_FILE=$HOME/.dotfiles/waybar/waybar-config
STYLE_FILE=$HOME/.cache/wal/waybar-style.css
temp_file=/tmp/waybar.tmp

if pgrep waybar 2> /dev/null; then
    # just reload running bar
    killall -q -SIGUSR2 waybar
    exit 0
fi

# Terminate already running bar instances
killall -q waybar
while pgrep waybar &> /dev/null; do
    sleep 0.3
done

printf "%s\n" "--- LAUNCH waybar ---" | tee -a "$temp_file"
waybar --config "$CONFIG_FILE" --style "$STYLE_FILE" 2>&1 | tee -a "$temp_file" & disown

printf "%s\n" "[Waybar]: Bar launched..."