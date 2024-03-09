#!/bin/bash

# TODO: Eu tenho que criar uma função que vai receber um username pra poder mandar pro meu greeter
# e esperar a resposta desse greeter, se ele responder com o prompt pro password é pq foi sucesso, se ele voltar com um erro é pq deu erro

start_session() {
	# local username="$1"
	# local json_value=$(eww_greetd login --username $username)

	# local status=$(jq -r '.status' <<< "$json_value")

	# if [[ $status -eq 200 ]]; then
	# 	eww update selected-user=$username
	# fi

	# echo "$json_value" | jq -c '.'
	eww_greetd login -u $username
}

start_session "$1"
