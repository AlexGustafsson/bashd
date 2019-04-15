#!/usr/bin/env bash

SERVER_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=./server.sh
source "$SERVER_CURRENT_DIRECTORY/http.sh"

export SERVER_HOST_ADDRESS="$SOCAT_SOCKADDR"
export SERVER_HOST_PORT="$SOCAT_SOCKPORT"
export SERVER_CLIENT_ADDRESS="$SOCAT_PEERADDR"
export SERVER_CLIENT_PORT="$SOCAT_PEERPORT"

declare -A SERVER_GET_HANDLERS=()

function route {
  if [[ "${1^^}" == "GET" ]]; then
    SERVER_GET_HANDLERS[$2]="$3"
  fi
}

function handleRequest {
  parseRequest
  if [[ ! -z "${SERVER_GET_HANDLERS[$HTTP_PATH]}" ]]; then
    ${SERVER_GET_HANDLERS[$HTTP_PATH]}
  else
    if [[ ! -z "${SERVER_GET_HANDLERS["404"]}" ]]; then
      ${SERVER_GET_HANDLERS["404"]}
    else
      setResponseCode "404"
      setResponseType "$HTTP_TYPE_PLAIN_TEXT"
      startResponse
      echo "Cannot $HTTP_METHOD $HTTP_PATH"
    fi
  fi
}
