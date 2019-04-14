#!/usr/bin/env bash

INDEX_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=../server.sh
source "$INDEX_CURRENT_DIRECTORY/../lib.sh"

parseRequest
respondWithHTML

cat << EOF
<html>
  <head></head>
  <body>
    <h1>Hello, World!</h1>
  </body>
</html>
EOF
