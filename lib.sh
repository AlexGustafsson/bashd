#!/usr/bin/env bash

LIB_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=./lib/colors.sh
source "$LIB_CURRENT_DIRECTORY/lib/colors.sh"
# shellcheck source=./lib/http.sh
source "$LIB_CURRENT_DIRECTORY/lib/http.sh"
# shellcheck source=./lib/logging.sh
source "$LIB_CURRENT_DIRECTORY/lib/logging.sh"
# shellcheck source=./lib/server.sh
source "$LIB_CURRENT_DIRECTORY/lib/server.sh"
