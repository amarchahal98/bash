#!/bin/bash

function myfunc()
{
args=$@

for each in $args;
do
find $each  > /dev/null 2>&1
nofail=$?


if [[ $nofail == 0 ]]; then
  echo "The filename $each exists."
  exit 0

else
  echo "The filename $each does not exist."
  exit 1

fi

done
}
myfunc $@
