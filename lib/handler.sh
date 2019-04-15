#!/usr/bin/env bash

HANDLER_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=./http.sh
source "$HANDLER_CURRENT_DIRECTORY/http.sh"

response="$("$HANDLER_CURRENT_DIRECTORY/../default/index.sh")"
exitCode="$?"

if [[ "$exitCode" -eq 0 ]]; then
  echo "$response"
else
  respondWithPlainText500
  echo "Internal Server Error"
fi
