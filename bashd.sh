#!/usr/bin/env bash

BASHD_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
LOG_PIPE="./logging.pipe"

function startLogging {
  trap "rm -f $LOG_PIPE" EXIT

  if [[ ! -p "$LOG_PIPE" ]]; then
      mkfifo "$LOG_PIPE"
  fi

  while true
do
    if read line <$LOG_PIPE; then
        echo $line
    fi
done
}

startLogging &

socat TCP-LISTEN:8080,fork,reuseaddr EXEC:"$BASHD_CURRENT_DIRECTORY/lib/handler.sh"
