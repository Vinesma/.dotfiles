#!/bin/bash

folder="$HOME/.dotfiles/scripts/newsboat"

[[ -e "$folder/unread_count" ]] && cat "$folder/unread_count" || echo ""
