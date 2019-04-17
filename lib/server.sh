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
declare -A SERVER_POST_HANDLERS=()

function route {
  debug "Adding route for $1 to $2"
  if [[ "${1^^}" == "GET" ]]; then
    SERVER_GET_HANDLERS[$2]="$3"
  elif [[ "${1^^}" == "POST" ]]; then
    SERVER_POST_HANDLERS[$2]="$3"
  fi
}

function handleRequestGET {
  debug "Handling GET $HTTP_PATH using defined route"
  ${SERVER_GET_HANDLERS[$HTTP_PATH]}
}

function handleRequestPOST {
  debug "Handling POST $HTTP_PATH using defined route"
  ${SERVER_POST_HANDLERS[$HTTP_PATH]}
}

function handleRequest {
  parseRequest
  info "Incoming request from $SERVER_CLIENT_ADDRESS for $HTTP_METHOD $HTTP_PATH"

  local handlerFound=0;
  [[ "$HTTP_METHOD" == "GET" ]] && [[ ! -z "${SERVER_GET_HANDLERS[$HTTP_PATH]}" ]] && handlerFound=1;
  [[ "$HTTP_METHOD" == "POST" ]] && [[ ! -z "${SERVER_POST_HANDLERS[$HTTP_PATH]}" ]] && handlerFound=1;

  if [[ "$handlerFound" -eq 0 ]]; then
    if [[ ! -z "${SERVER_GET_HANDLERS["404"]}" ]]; then
      debug "Handling $HTTP_METHOD $HTTP_PATH using defined 404 route"
      ${SERVER_GET_HANDLERS["404"]}
    else
      debug "Handling $HTTP_METHOD $HTTP_PATH using default 404 route"
      setResponseCode "404"
      setResponseType "$HTTP_TYPE_PLAIN_TEXT"
      startResponse
      echo "Cannot $HTTP_METHOD $HTTP_PATH"
    fi

    return
  fi

  if [[ "${HTTP_METHOD^^}" == "GET" ]]; then
    handleRequestGET
  elif [[ "${HTTP_METHOD^^}" == "POST" ]]; then
    handleRequestPOST
  fi
}
