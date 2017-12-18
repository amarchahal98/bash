#!/bin/bash


file_name=$1

find $file_name > /dev/null 2>&1



name_exit=$?


if [[ $name_exit == 0 ]]; then
  echo "The filename $file_name exists"
  exit 0
else
  echo "The filename $file_name can't be found."
  exit 1

fi
