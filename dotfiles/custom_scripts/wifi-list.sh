#!/bin/bash

output=$(nmcli -t -c no -f SSID,SIGNAL,ACTIVE,SECURITY device wifi list | sort -t ':' -k 3,3r -k 2,2nr | grep -v '^:')

line_number=1
num_lines=$(echo "$output" | wc -l)
printf '['
while IFS=':' read -r ssid signal active security; do
	if [[ $signal -ge 70 ]]; then
		signal="󰤨"
	elif [[ $signal -ge 50 ]]; then
		signal="󰤥"
	elif [[ $signal -ge 30 ]]; then
		signal="󰤢"
	else
		signal="󰤟"
	fi

	# TODO: i18n conditional
	if [[ $active == "sim" ]]; then
		active=""
	else
		active=""
	fi

	if [[ -z $security ]]; then
		security=""
	else
		security="󰌾"
	fi
	if [[ "$num_lines" -eq "$line_number" ]]; then
		printf '{"SSID": "%s", "Signal": "%s", "Active": "%s", "Security": "%s"}]' "$ssid" "$signal" "$active" "$security"
		exit
	else
		printf '{"SSID": "%s", "Signal": "%s", "Active": "%s", "Security": "%s"},' "$ssid" "$signal" "$active" "$security"
	fi
	((line_number++))
done <<< "$output"
