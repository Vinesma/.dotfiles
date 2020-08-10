#!/bin/bash

folder="$HOME/.dotfiles/scripts/newsboat"

[[ -e "$folder/unread_count.tmp" ]] && cat "$folder/unread_count.tmp" || echo ""
