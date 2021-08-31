#!/bin/bash

state=$(nmcli n connectivity check)

echo "Connectivity status: $state"
echo -e "Checking ping...\n"

ping -c 5 archlinux.org
