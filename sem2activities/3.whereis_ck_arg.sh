#!/bin/bash
#===================================================================
#
#	FILE: whereis_ck_arg.sh
#
#	USAGE: ./whereis_ck_arg.sh
#
#	DESCRIPTION: Accepts arguments to locate commands.
#
#	OPTIONS: ---
#	REQUIREMENTS: ---
#	BUGS: ---
#	NOTES: ---
#	AUTHOR: Amar Chahal
#	ORGANIZATION: BCIT
#	CREATED: 4/10/2017 11:57
#	REVISION: ---
#
#===================================================================


command_name=$@




type_output=$( type $command_name 2> /dev/null )
command_available=$?

type_output=$( echo $type_output | cut -f3 -d" " ) 



# This provides the if/else statements. If "if" is not met, it goes to "else".


if [[ $command_available == 0 ]] ; then
  echo "$command_name is installed"
  echo "The command $command_name is located in $type_output."


else
  echo "$command_name is not installed :("
fi

echo "Exit code of the function: $command_available"

exit $command_available

