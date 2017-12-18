#!/bin/bash
#Checks if DHCP is available. If not, it will install it.

import sourcelist.sh

type dhcpd
dhcp_avail=$?

if [[ $dhcp_avail == 1 ]]; then
  echo "You do not have DHCP installed. It is being installed and configured now."
  yum install -y dhcp 2>&1 /dev/null
else
  echo "You have DHCP installed. Configuring now."

#Removes existing config files and adds the new configured one.
rm -f /etc/dhcp/dhcpd.conf
touch /etc/dhcp/dhcpd.conf
cat > /etc/dhcp/dhcpd.conf << CONF
        subnet 10.16.$sid.0 netmask 255.255.255.128 {
        option routers 10.16.$sid.126;
        option subnet-mask 255.255.255.128;
        option broadcast-address 10.16.$sid.127;
        range 10.16.$sid.100 10.16.$sid.126;
}
# Mail Server's Static IP Assignment
host 12MS {
        hardware ethernet 08:00:27:72:28:AC;
        fixed-address 10.16.$sid.1;
}

	subnet 10.16.$sid.128 netmask 255.255.255.128 {
	option routers 10.16.$sid.129;
	option subnet-mask 255.255.255.128;
	option broadcast-address 10.16.$sid.255;
	option domain-name-servers 10.16.$sid.126;
	range 10.16.$sid.129 10.16.$sid.254;
}

CONF
cd ~
wget https://www.internic.net/domain/named.cache
mv ~/named.cache /etc/unbound
mv /etc/unbound/named.cache /etc/unbound/root.hints
cd -

#Starts the services.
systemctl start dhcpd
systemctl enable dhcpd
echo "DHCP is now running on `hostname`"
fi
