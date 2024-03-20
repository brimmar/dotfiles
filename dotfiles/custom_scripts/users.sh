#!/bin/bash

users_json=$(
	getent passwd | grep /home/ | {
		while IFS=':' read -r username x uid gid blah home shell; do
			username_esc=$(echo "$username" | sed 's/\\//g' | sed 's/"/\\"/g')
			home_esc=$(echo "$home" | sed 's/\\//g' | sed 's/"/\\"/g')
			face_dir="$home_esc/.face"

			if [ -d "$face_dir" ]; then
				face_file=$(find "$face_dir" -type f -print)
				if [ -f "$face_file" ]; then
					face_file_esc=$(echo "$face_file" | sed 's/\\//g' | sed 's/"/\\"/g')
					colors=$(okolors "$face_file_esc" -k 2 -o rgb)
					primary_color=$(echo "$colors" | cut -d ' ' -f1)
					secondary_color=$(echo "$colors" | cut -d ' ' -f2)
					user_info="{\"username\":\"$username_esc\",\"uid\":$uid,\"gid\":$gid,\"home\":\"$home_esc\",\"shell\":\"$shell\",\"face_file\":\"$face_file_esc\",\"primary_color\":\"$primary_color\",\"secondary_color\":\"$secondary_color\"},"
				else
					user_info="{\"username\":\"$username_esc\",\"uid\":$uid,\"gid\":$gid,\"home\":\"$home_esc\",\"shell\":\"$shell\",\"face_file\": null, \"primary_color\": null,\"secondary_color\": null},"
				fi
			else
				user_info="{\"username\":\"$username_esc\",\"uid\":$uid,\"gid\":$gid,\"home\":\"$home_esc\",\"shell\":\"$shell\",\"face_file\": null, \"primary_color\": null,\"secondary_color\": null},"
			fi

			users_json+="$user_info"
		done

		echo $users_json
	}
)

echo "[${users_json%?}]"
