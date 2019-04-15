#!/usr/bin/env bash

HANDLER_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=./http.sh
source "$HANDLER_CURRENT_DIRECTORY/http.sh"
# shellcheck source=./logging.sh
source "$HANDLER_CURRENT_DIRECTORY/logging.sh"

response="$("$HANDLER_CURRENT_DIRECTORY/../default/index.sh")"
exitCode="$?"

if [[ "$exitCode" -eq 0 ]]; then
  echo "$response"
else
  warn "Server failed to respond $HTTP_PATH"
  setResponseCode "500"
  setResponseType "$HTTP_TYPE_PLAIN_TEXT"
  startResponse
  echo "Internal Server Error"
fi
