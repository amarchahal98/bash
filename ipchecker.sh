#!/bin/bash

# Check to see if IP is valid using Regex


function check_ip()
	{
	local ip=$1
	local exit=1

	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		IFS='.'
		ip=($ip)
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
		exit=$?
	fi
	return $exit
}
check_ip "$1"
