#!/bin/bash

notify_send_dir="/usr/bin/notify-send"
mpc_dir="/usr/bin/mpc"

$mpc_dir crop
$mpc_dir search '(genre contains "epic")' | $mpc_dir add
$mpc_dir random on
$mpc_dir repeat on

$notify_send_dir "MPD" "Queue set to 'epic'"


