#!/bin/bash
#
# Simple script meant to be used as a module, shows up if redshift is running.
# Named tempsetter check to avoid being murdered by any killall command.

if pgrep -u "$UID" redshift >/dev/null; then
    echo "ﯦ"
else
    echo ""
fi
