#!/bin/sh

if ! ip addr show | \
  grep -G "inet \([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}" | \
  grep -G -e "wlan0" -e "enp1s0" >/dev/null 2>/dev/null ; then
    exit 1
fi
