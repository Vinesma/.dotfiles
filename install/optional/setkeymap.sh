#!/bin/sh

keymp="br"

echo "- Setting keymap..."
localectl --no-convert set-x11-keymap $keymp
echo "Keymap set, a restart is required"
echo

echo "Done."
