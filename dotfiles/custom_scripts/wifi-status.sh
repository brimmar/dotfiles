#!/bin/bash

# TODO: i18n conditional
connected_interface=$(nmcli device | grep -i wifi | grep -iw 'conectado' | awk '{print $1}')

if [[ -z $connected_interface ]]; then
	echo "󰤭"
	exit 0
fi

iw_output=$(iwconfig $connected_interface)

link_quality=$(echo "$iw_output" | grep "Link Quality" | awk '{print $2}')

link_quality=$(echo "$link_quality" | cut -d'/' -f1)

link_quality_percentage=$(( link_quality * 100 / 70 ))

if [[ $link_quality_percentage -ge 70 ]]; then
    echo "󰤨"
elif [[ $link_quality_percentage -ge 50 ]]; then
    echo "󰤥"
elif [[ $link_quality_percentage -ge 30 ]]; then
    echo "󰤢"
else
    echo "󰤟"
fi
