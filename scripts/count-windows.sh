#!/bin/bash
#
# Script meant to be run by a polybar module, returns number of open windows.
#

qtilecmd_dir="/usr/bin/qtile-cmd"

window_count="$($qtilecmd_dir -o cmd -f windows | grep -c name)"
# no. of windows minus polybar
true_count="$(( window_count - 1 ))"

[[ "$true_count" -gt 1 ]] && echo "$true_count" || echo ""
