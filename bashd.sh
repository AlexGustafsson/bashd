#!/usr/bin/env bash

BASHD_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
PORT="${1:-8080}"
export SITE_ENTRYPOINT="${2:-"$BASHD_CURRENT_DIRECTORY/default"}"

# shellcheck source=./lib/logging.sh
source "$BASHD_CURRENT_DIRECTORY/lib/logging.sh"

LOG_PIPE="./logging.pipe"

function startLogging {
  trap "rm -f $LOG_PIPE" EXIT

  if [[ ! -p "$LOG_PIPE" ]]; then
      mkfifo "$LOG_PIPE"
  fi

  while true; do
    while read -r line; do
      echo "$line"
    done <"$LOG_PIPE"
  done
}

startLogging &

debug "Started logging service"

if [[ -z "$2" ]]; then
  warn "Serving default site"
else
  if [[ ! -p "$SITE_ENTRYPOINT" ]]; then
    warn "Given entrypoint ($SITE_ENTRYPOINT) not found. Using default site"
    SITE_ENTRYPOINT="$BASHD_CURRENT_DIRECTORY/default"
  fi
fi

info "Listening on :$PORT"
socat TCP-LISTEN:"$PORT",fork,reuseaddr EXEC:"$BASHD_CURRENT_DIRECTORY/lib/handler.sh"
