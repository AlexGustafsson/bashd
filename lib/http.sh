#!/usr/bin/env bash

export HTTP_TYPE_PLAIN_TEXT="text/plain; charset=utf-8"
export HTTP_TYPE_HTML="text/html; charset=utf-8"

export HTTP_CODE_OK="200 OK"
export HTTP_CODE_INTERNAL_SERVER_ERROR="500"

export HTTP_RESPONSE_CODE="$HTTP_CODE_OK"
export HTTP_RESPONSE_TYPE="$HTTP_TYPE_HTML"

export HTTP_REQUEST=""
export HTTP_VERSION=""
export HTTP_METHOD=""
export HTTP_PATH=""
export HTTP_HOST=""
export HTTP_USER_AGENT=""
export HTTP_CONTENT_TYPE=""
export HTTP_BODY=""

function readRequest {
  # Read the HTTP request from STDIN.
  # Allow for some time to pass before considering STDIN dead.
  while read -t 0.1 line; do
    echo "$line"
  done
  # The read test may fail if there's no new line at the end, make up for this
  [[ "$line" ]] && echo "$line"
}

function parseRequest {
  # Convert the read request to regular LF
  HTTP_REQUEST="$(readRequest | tr -d '\r')"

  HTTP_VERSION="$(head -1 <<<"$HTTP_REQUEST" | cut -d' ' -f3)"
  HTTP_METHOD="$(head -1 <<<"$HTTP_REQUEST" | cut -d' ' -f1)"
  HTTP_PATH="$(head -1 <<<"$HTTP_REQUEST" | cut -d' ' -f2)"
  HTTP_HOST="$(getHeader "Host")"
  HTTP_USER_AGENT="$(getHeader "User-Agent")"
  HTTP_CONTENT_TYPE="$(getHeader "Content-Type")"

  if [[ "$HTTP_CONTENT_TYPE" == 'application/x-www-form-urlencoded' ]]; then
    parseFormURLEncoded
  fi
}

function urldecode {
  while read; do : "${REPLY//%/\\x}"; echo -e ${_//+/ }; done
}

function parseFormURLEncoded {
  local firstEmpty="$(grep --line-number '^$' <<<"$HTTP_REQUEST" | head -1 | cut -d: -f1)"
  HTTP_BODY="$(tail -n +"$(($firstEmpty + 1))" <<<"$HTTP_REQUEST")"

  local oldIFS="$IFS"
  IFS='=&'
  local values=($HTTP_BODY)
  IFS="$oldIFS"
  for ((i=0; i<${#values[@]}; i+=2)); do
    declare -gx HTTP_BODY_${values[i]^^}="$(echo "${values[i+1]}" | urldecode)"
  done
}

function getHeader {
  grep -i "^$1:" <<<"$HTTP_REQUEST" | sed 's/^[^:]\{1,\}: \(.\{0,\}\)/\1/'
}

function setResponseCode {
  HTTP_RESPONSE_CODE="$1"
}

function setResponseType {
  HTTP_RESPONSE_TYPE="$1"
}

function startResponse {
  echo "HTTP/1.1 $HTTP_RESPONSE_CODE"
  echo "Content-Type: $HTTP_RESPONSE_TYPE"
  echo ""
}
