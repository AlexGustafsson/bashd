Bashd - A PoC CGI-styled web server and framework written in Bash
======

![Demo](https://github.com/AlexGustafsson/bashd/raw/master/assets/demo.png)

# Quickstart
<a name="quickstart"></a>

Clone the project
```
git clone https://github.com/AlexGustafsson/bashd
```
Navigate to the folder
```
cd bashd
```
Start the server
```
./bashd
```

# Table of contents

[Quickstart](#quickstart)<br/>
[Features](#features)<br/>
[Usage](#usage)<br/>
[Contributing](#contributing)<br/>
[FAQ](#faq)<br/>

# Features
<a name="features"></a>

* 🔥 Not incredibly slow (300ms for a response)
* 🛣 Routing
* 📭 Easy-to-use POST support
* 🔒 Security by obscurity. Who's expecting a Bash web server?

# Usage
<a name="usage"></a>

**Defining a route**

```bash
route get / homePage
# Special 404 route - handles all 404s
route get 404 notFoundPage
# POST a message to the echo page to hear it back louder!
route post /echo echoPage
```

**Handling pages**

```bash
function homePage {
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

function notFoundPage {
  setResponseCode "404"
  startResponse
  cat << EOF
<html>
  <head></head>
  <body>
    <h1>Cannot find $HTTP_METHOD $HTTP_PATH</h1>
  </body>
</html>
EOF
}

function echoPage {
  startResponse
  cat << EOF
<html>
  <head></head>
  <body>
    <h1>${HTTP_BODY_MESSAGE^^}</h1>
  </body>
</html>
EOF
}
```

# FAQ
<a name="faq"></a>

**Q**: Does it work?
**A**: Yes.

**Q**: Is it safe?
**A**: No.

**Q**: Is it a joke?
**A**: Mostly.

# Contributing
<a name="contributing"></a>

Any help with the project is more than welcome. When in doubt, post an issue.
