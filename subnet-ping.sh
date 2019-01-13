#!/bin/bash

subnet_ping() {
  local subnet

  [ -z "$1" ] && subnet=1 || subnet=$1

  for ip in 192.168.$subnet.{1..254}; do
    (ping -c 1 -W 1 $ip | grep "64 bytes" | cut -c 15- &)
  done
  sleep 1
}

