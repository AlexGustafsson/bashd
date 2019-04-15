#!/usr/bin/env bash

INDEX_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=../server.sh
source "$INDEX_CURRENT_DIRECTORY/../lib.sh"

function home {
  respondWithHTML
  cat << EOF
<html>
  <head></head>
  <body>
    <h1>Hello, World!</h1>
  </body>
</html>
EOF
}

function default {
  respondWithHTML404
  cat << EOF
<html>
  <head></head>
  <body>
  <center>
    <marquee direction="down" width="250" behavior="alternate" style="font-size: 48px; height: 48px">
      <marquee behavior="alternate">
        404
      </marquee>
    </marquee>
    <p>Could not find $HTTP_PATH</p>
    <a href="/">Go back home</a>
  </center>
  </body>
</html>
EOF
}

route "GET" "/" home
route "GET" "404" default

handle
