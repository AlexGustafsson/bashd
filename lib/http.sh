#!/usr/bin/env bash

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

function respondWithPlainText {
  echo "HTTP/1.1 200 OK"
  echo "Content-Type: text/plain; charset=utf-8"
  echo ""
}

function respondWithPlainText404 {
  echo "HTTP/1.1 404"
  echo "Content-Type: text/plain; charset=utf-8"
  echo ""
}

function respondWithHTML {
  echo "HTTP/1.1 200 OK"
  echo "Content-Type: text/html; charset=utf-8"
  echo ""
}

function respondWithHTML404 {
  echo "HTTP/1.1 404"
  echo "Content-Type: text/html; charset=utf-8"
  echo ""
}

function respondWithPlainText500 {
  echo "HTTP/1.1 500"
  echo "Content-Type: text/html; charset=utf-8"
  echo ""
}
