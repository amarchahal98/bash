# Simple script to clear log files in /var/log
# Run as Root.

cd /var/log
cat /dev/null > messages
cat /dev/null > otherlogs

echo "Log files have been cleaned."


