#!/bin/bash

# It runs a command in background and redirect error output to /dev/null
rib() {
  local app=$1
  shift
  $app "${@}" 2> /dev/null &
}
