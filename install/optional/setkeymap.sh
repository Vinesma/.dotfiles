#!/bin/bash

keymp="br"

echo "==> Setting keymap..."
localectl --no-convert set-x11-keymap $keymp
echo "-> Keymap set, a restart is required"
echo "-> Done."
