#!/bin/bash

# FILES AND FOLDERS
main_folder="$HOME/.dotfiles/install"
pack_lists="$main_folder/packlists"

# Load helper functions
. "$main_folder/helper-functions.sh"

header-msg "Setting up email with neomutt/isync"
config-by-file "$pack_lists/email"
arrow-msg "Creating folders."
create-dir-function "$HOME/mail/gmail/"
arrow-msg "Copying mailcap for using w3m to view html in neomutt."
create-copy-function "$HOME/.dotfiles/.mailcap" "$HOME/.mailcap"
info-msg "A script for cron is provided in \`$HOME/.dotfiles/scripts/cron-jobs\`, it's suggested to run it in 10 minute intervals."
info-msg "Setting up a gpg keypair is necessary for keeping your password secure and, by extension, be able to use neomutt."
info-msg "Save your password inside \`$HOME/.neomutt/account.gpg\`"
