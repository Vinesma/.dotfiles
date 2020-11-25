#!/bin/bash

main_folder="$HOME/.mail/gmail/Inbox/new"
new_mail=$(find "$main_folder" -type f | wc -l)

if [[ "$new_mail" -ne 0 ]]; then
    echo "$new_mail"
else
    echo ""
fi
