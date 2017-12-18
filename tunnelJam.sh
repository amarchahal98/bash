#!/bin/bash

# Re-initalizes reverse SSH connection if it is down.

# sship=

IP=
netstat -an | grep "${IP}:8505        ESTABLISHED"

alive=$?

if [[ $alive == 1 ]]; then
  ssh -o ServerAliveInterval=30 -o ServerAliveCountMax=1 -N -R 5908:localhost:5901 achahal@$sship -p 8505
  exit

else
  exit

fi
