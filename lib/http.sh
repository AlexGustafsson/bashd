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

function parseRequest {
  # Read the HTTP request from STDIN.
  # Allow for some time to pass before considering STDIN dead.
  while read -t 0.1 line; do
    HTTP_REQUEST="${HTTP_REQUEST}$line\n"
  done
  HTTP_REQUEST="$(echo -e "$HTTP_REQUEST")"

  function getHeader {
    grep -i "^$1:" <<<"$HTTP_REQUEST" | sed 's/^[^:]\{1,\}: \(.\{0,\}\)/\1/'
  }

  HTTP_VERSION="$(head -1 <<<"$HTTP_REQUEST" | cut -d' ' -f3)"
  HTTP_METHOD="$(head -1 <<<"$HTTP_REQUEST" | cut -d' ' -f1)"
  HTTP_PATH="$(head -1 <<<"$HTTP_REQUEST" | cut -d' ' -f2)"
  HTTP_HOST="$(getHeader "Host")"
  HTTP_USER_AGENT="$(getHeader "User-Agent")"
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
