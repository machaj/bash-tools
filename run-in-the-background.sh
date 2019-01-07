#!/bin/bash

# Run In the Backgrount
rib() {
  local app=$1
  shift
  $app "${@}" 2> /dev/null &
}
