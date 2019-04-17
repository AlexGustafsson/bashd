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
    <h2>This is the default (demo) page!</h2>
    <a href="/ping">Pinging service</a>
    <a href="/encrypt">AES encryption service</a>
    <a href="/decrypt">AES decryption service</a>
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

function encrypt {
  startResponse
  encrypted="$(echo "$HTTP_BODY_MESSAGE" | openssl enc -aes-256-cbc -salt -a -k "$HTTP_BODY_PASSWORD" -in /dev/stdin)"
  cat << EOF
  <html>
    <head></head>
    <body>
      <h1>Encrypt</h1>
      <a href="/decrypt">go to decrypt page</a>
      <form action="/encrypt" method="post">
        <input type="text" name="message" placeholder="message to encrypt" />
        <input type="password" name="password" placeholder="password to use" />
        <input type="submit" />
      </form>
      <p>Encrypted: $encrypted</p>
    </body>
  </html>
EOF
}

function decrypt {
  startResponse
  decrypted="$(echo "$HTTP_BODY_MESSAGE" | openssl enc -a -aes-256-cbc -d -k "$HTTP_BODY_PASSWORD" -in /dev/stdin)"
  cat << EOF
  <html>
    <head></head>
    <body>
      <h1>Decrypt</h1>
      <a href="/encrypt">go to encrypt page</a>
      <form action="/decrypt" method="post">
        <input type="text" name="message" placeholder="message to decrypt" />
        <input type="password" name="password" placeholder="password to use" />
        <input type="submit" />
      </form>
      <p>Decrypted: $decrypted</p>
    </body>
  </html>
EOF
}

route "GET" "/" home
route "GET" "404" default

route "POST" "/ping" ping
route "GET" "/ping" ping

route "POST" "/encrypt" encrypt
route "GET" "/encrypt" encrypt

route "POST" "/decrypt" decrypt
route "GET" "/decrypt" decrypt

handleRequest
