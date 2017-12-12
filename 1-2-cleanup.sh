#!/bin/bash

logdir=/var/log

cd $logdir

cat /dev/null > messages
cat /dev/null > otherlogs

echo "Log files have been cleaned."


# Exit without an argument will return exit code of previous command.
exit


