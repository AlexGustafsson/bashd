#!/usr/bin/env bash

LOGGING_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
LOG_PIPE="./logging.pipe"

# shellcheck source=./colors.sh
source "$LOGGING_CURRENT_DIRECTORY/colors.sh"

function debug {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_BLUE}debug${COLOR_RESET}] " > "$LOG_PIPE"
  echo "$@" > "$LOG_PIPE"
}

function info {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_GREEN}info${COLOR_RESET} ] " > "$LOG_PIPE"
  echo "$@" > "$LOG_PIPE"
}

function warn {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_YELLOW}warn${COLOR_RESET} ] " > "$LOG_PIPE"
  echo "$@" > "$LOG_PIPE"
}

function error {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_RED}error${COLOR_RESET}] " > "$LOG_PIPE"
  echo "$@" > "$LOG_PIPE"
}

function fatal {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_RED}fatal${COLOR_RESET}] " > "$LOG_PIPE"
  echo "$@" > "$LOG_PIPE"
  exit 1
}
