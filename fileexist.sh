#!/bin/bash

filename=$1

echo $filename
if [ -e "$filename" ];
then
  echo "$filename exists."

else
  echo "$filename does not exist."

fi

# 'r' and 'w' can be used instead of x for read/write permissions respectively.
if [ -x "$filename" ];
then
  echo "$filename has execute permissions."

else
echo "$filename does not have execute permissions."

fi

if [ -f "$filename" ];
then
  echo "$filename is a regular file."

else
  echo "$filename is not a regular file."
fi

if [ -d "$filename" ];
then
  echo "$filename is a directory."

else
  echo "$filename is not a directory."

fi


