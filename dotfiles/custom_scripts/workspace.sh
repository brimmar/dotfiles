#!/bin/bash

PID_FILE='/home/brimmar/pid'

kill_pid() {
	if [ -f $PID_FILE ]; then
		kill $(cat $PID_FILE)
		rm $PID_FILE
	fi
}

reset_var_to_false() {
	sleep 1
	~/eww/target/release/eww close workspace &
	rm $PID_FILE
}

open_workspace() {
	is_open=$(~/eww/target/release/eww active-windows | grep 'workspace')
	if [[ -z $is_open ]]; then
		~/eww/target/release/eww open workspace
	fi
}

handle() {
	case $1 in
		workspace*)
			kill_pid
			~/eww/target/release/eww update workspace=${1#*>>} &
			open_workspace
			reset_var_to_false &
			echo $! > $PID_FILE
			;;
	esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
