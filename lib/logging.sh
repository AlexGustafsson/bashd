#!/usr/bin/env bash

LOGGING_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=./colors.sh
source "$LOGGING_CURRENT_DIRECTORY/colors.sh"

function debug {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_BLUE}debug${COLOR_RESET}] "
  echo "$@"
}

function warn {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_YELLOW}warn${COLOR_RESET} ] "
  echo "$@"
}

function error {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_RED}error${COLOR_RESET}] "
  echo "$@"
}

function fatal {
  now="$(date +"%T")"
  echo -ne "$now [${COLOR_FOREGROUND_RED}fatal${COLOR_RESET}] "
  echo "$@"
  exit 1
}
