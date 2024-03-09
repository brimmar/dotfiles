#!/bin/bash

while true; do
	read length_microseconds
	if [[ -n "$length_microseconds" ]]; then
		length_seconds=$((length_microseconds / 1000000))
		minutes=$((length_seconds / 60))
		seconds=$((length_seconds % 60))
		printf "%02d:%02d\n" "$minutes" "$seconds"
	fi
done
