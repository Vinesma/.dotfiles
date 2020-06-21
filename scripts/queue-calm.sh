#!/bin/bash

notify_send_dir="/usr/bin/notify-send"
mpc_dir="/usr/bin/mpc"

$mpc_dir crop
$mpc_dir search '(genre contains "calm")' | $mpc_dir add

$notify_send_dir "MPD" "Queue set to 'calm'"



