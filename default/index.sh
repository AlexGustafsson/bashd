#!/usr/bin/env bash

INDEX_CURRENT_DIRECTORY="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# shellcheck source=../server.sh
source "$INDEX_CURRENT_DIRECTORY/../lib.sh"

function home {
  startResponse
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
  setResponseCode "404"
  startResponse
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

function ping {
  startResponse
  cat << EOF
  <html>
    <head></head>
    <body>
      <form action="/ping" method="post">
        <input type="text" name="message" placeholder="message" />
        <input type="submit" />
      </form>
      <p>Message: $HTTP_BODY_MESSAGE</p>
    </body>
  </html>
EOF
}

route "GET" "/" home
route "GET" "404" default
route "POST" "/ping" ping
route "GET" "/ping" ping

handleRequest
