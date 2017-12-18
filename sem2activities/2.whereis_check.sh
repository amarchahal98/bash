#!/bin/bash
#===================================================================
#
#	FILE: mycheck.sh 
#
#	USAGE: ./mycheck.sh
#
#	DESCRIPTION: Tells the user if a command exists, and where it is located
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

set -o nounset #This will make unset variables return an error


# Declaring the variables we will need for the following script.

# Declares Script Version.
declare -r SCRIPTVERSION="1.0"
# Declares the name of the user's inputted command.
declare command_name
# Declares the output of the command's location
declare type_output
# Declares whether the command is available, and sets default exit code as 1.
# "-i" defines an integer
declare -i command_available=1

# echo's the following text and then asks for user input which it stores as a variable.
# "-p" allows for a prompt from the user.
read -p "Please type the name of the command you would like to find: " \
  command_name

# Will read input from the type command and store it as a variable, along with the exit code.

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

