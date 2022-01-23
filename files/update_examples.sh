#!/usr/bin/env bash

DOTFILES_FILES=$HOME/.dotfiles/files

crontab -l > "$DOTFILES_FILES/crontab_example"
cat /etc/anacrontab > "$DOTFILES_FILES/anacron_example"