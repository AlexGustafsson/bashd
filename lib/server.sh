#!/usr/bin/env bash

SERVER_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=./server.sh
source "$SERVER_CURRENT_DIRECTORY/http.sh"
# shellcheck source=./logging.sh
source "$SERVER_CURRENT_DIRECTORY/logging.sh"

export SERVER_HOST_ADDRESS="$SOCAT_SOCKADDR"
export SERVER_HOST_PORT="$SOCAT_SOCKPORT"
export SERVER_CLIENT_ADDRESS="$SOCAT_PEERADDR"
export SERVER_CLIENT_PORT="$SOCAT_PEERPORT"

declare -A SERVER_GET_HANDLERS=()

function route {
  debug "Adding route for $1 to $2"
  if [[ "${1^^}" == "GET" ]]; then
    SERVER_GET_HANDLERS[$2]="$3"
  fi
}

function handleRequest {
  parseRequest
  info "Incoming request from $SERVER_CLIENT_ADDRESS for $HTTP_PATH"
  if [[ ! -z "${SERVER_GET_HANDLERS[$HTTP_PATH]}" ]]; then
    debug "Handling $HTTP_PATH using defined route"
    ${SERVER_GET_HANDLERS[$HTTP_PATH]}
  else
    if [[ ! -z "${SERVER_GET_HANDLERS["404"]}" ]]; then
      debug "Handling $HTTP_PATH using defined 404 route"
      ${SERVER_GET_HANDLERS["404"]}
    else
      debug "Handling $HTTP_PATH using default 404 route"
      setResponseCode "404"
      setResponseType "$HTTP_TYPE_PLAIN_TEXT"
      startResponse
      echo "Cannot $HTTP_METHOD $HTTP_PATH"
    fi
  fi
}
