#!/bin/bash

result=$(nmcli con up id "$1")
if [[ $? -eq 0 ]]; then
	exit 0
else
    ~/eww/target/release/eww open-many overlay wifi-connect-window && ~/eww/target/release/eww update overlay-window='wifi-connect-window' && ~/eww/target/release/eww update wifiSSID="$1"
fi
