#!/bin/bash

logdir=/var/log
root_uid=0
id_notroot=3
LINES=50


# Root Check
if [[ $EUID -ne $root_uid ]];
then
  echo "You do not have root access."
  exit $id_notroot
fi

# Test if argument was used
if [ -n "$1" ];
then
  lines=$1
else
  lines=$LINES # Default if no argument provided

