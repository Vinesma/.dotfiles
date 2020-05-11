#!/bin/sh

keymp="br"

echo "- Setting keymap..."
localectl --no-convert set-x11-keymap $keymp
echo "This could require a restart"
echo

echo "Done."
