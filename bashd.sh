#!/usr/bin/env bash

BASHD_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

source "lib.sh"

if [[ ! -z ${COLOR_SUPPORTS_256+x} ]]; then
  debug "Supports 256 colors"
fi

debug "Starting"
# -T 1
socat -d -d TCP-LISTEN:8080,fork,reuseaddr EXEC:"$BASHD_CURRENT_DIRECTORY/default/index.sh"
