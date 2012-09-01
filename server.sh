#!/usr/bin/env bash

port='9876'

_open='xdg-open' # freedesktop.org open
if ! type -p "$_open" >/dev/null 2>&1;then
  _open='open' # BSD open
fi

node gen_jstd_configs.js
java -jar lib/jstestdriver/JsTestDriver.jar \
  --port "$port" --browserTimeout 90000 &

sleep 1
printf 'Start and backgrounded server on port "%d", PID is: %s\n' \
  "$port" $(fuser -n tcp "$port")

echo 'Waiting 3 second and opening testdriver slave in browser...'
sleep 3 && "$_open" "http://localhost:${port}/capture" & disown

# block on something, not returning from this script, then
# capture INTERUPT and kill `fuser` result??
