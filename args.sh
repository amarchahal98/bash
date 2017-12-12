#!/bin/bash

e_wrong_arg=10
script_parameters="[-a] [-h]"
correctargnum=2


# $# outputs the amount of arguments used.
if [[ $# -ne $correctargnum ]]
then
  echo "Usage: `basename $0` $script_parameters"
  exit $e_wrong_arg

fi

