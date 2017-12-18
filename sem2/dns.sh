#!/bin/bash
import sourcelist.sh
#Configuring Unbound


yum -y install unbound nsd 2>&1 /dev/null
rm -rf /etc/unbound/unbound.conf
touch /etc/unbound/unbound.conf
cat > /etc/unbound/unbound.conf << EOF
server:
        interface: 10.16.$sid.126
	    interface: 10.16.$sid.129
        port: 53
        do-ip4: yes
        do-ip6: no
        access-control: 3.0.0.0/0 refuse
        access-control: ::0/0 refuse
        access-control: 10.16.255.0/24 refuse
	access-control: 10.16.$sid.128/25 allow
        access-control: 10.16.1.0/25 allow
        chroot: ""
        username: "unbound"
        directory: "/etc/unbound"
        root-hints: "/etc/unbound/root.hints"
        pidfile: "/var/run/unbound/unbound.pid"
        prefetch: yes
        module-config: "iterator"
        include: /etc/unbound/local.d/*.conf

remote-control:
        control-enable: yes
        server-key-file: "/etc/unbound/unbound_server.key"
        server-cert-file: "/etc/unbound/unbound_server.pem"
        control-key-file: "/etc/unbound/unbound_control.key"
        control-cert-file: "/etc/unbound/unbound_control.pem"
        include: /etc/unbound/conf.d/*.conf

stub-zone:
        name: "s01.as.learn"
        stub-addr: 10.16.255.1

stub-zone:
        name: "1.16.10.in-addr.arpa"
        stub-addr: 10.16.255.1

forward-zone:
	name: "learn"
	forward-addr: 142.232.221.253

forward-zone:
	name: "bcit.ca"
	forward-addr: 142.232.221.253

forward-zone:
	name: "htpbcit.ca"
	forward-addr: 142.232.221.253

EOF
touch /etc/nsd/nsd.conf
cat > /etc/nsd/nsd.conf << NSDEOF
server:
	ip-address: 10.16.255.1
	do-ip6: no
	verbosity: 10
	include: "/etc/nsd/server.d/*.conf"

include: "/etc/nsd/conf.d/*.conf"
remote-control:
	control-enable: yes

zone:
	name: "s01.as.learn"
	zonefile: "s01.as.learn.zone"

zone:
	name: "1.16.10.in-addr.arpa"
	zonefile: "1.16.10.in-addr.arpa.zone"

NSDEOF
touch /etc/nsd/1.16.10.in-addr.arpa.zone
cat > /etc/nsd/1.16.10.in-addr.arpa.zone << EOF
\$TTL 10s
1.16.10.in-addr.arpa.    IN  SOA  rtr.s01.as.learn. tlane.bcit.ca. (
                        2016030101    ; serial number of Zone Record
                        1200s         ; refresh time
                        180s          ; retry time on failure
                        1d            ; expiration time
                        3600          ; cache time to live
                        )

;Name servers for this domain
1.16.10.in-addr.arpa.    IN  NS  s01rtr.as.learn.

126.1.16.10.in-addr.arpa.  IN  PTR  rtr.s01.as.learn.
100.1.16.10.in-addr.arpa.  IN  PTR  mail.s01.as.learn.



EOF
cat > /etc/nsd/s01.as.learn.zone << EOF
$TTL 10s                              ; 10 secs default TTL for zone
s01.as.learn.    IN  SOA   s01rtr.as.learn. hi (
                        2014022501    ; serial number of Zone Record
                        1200s         ; refresh time
                        180s          ; update retry time on failure
                        1d            ; expiration time (if the primary server does not reply then the server will stop replying to the clients)
                        3600          ; cache time to live (for this SOA record)
                        )

;Name servers for this domain
s01.as.learn.    IN  NS     s01rtr.as.learn.

mail.s01.as.learn.  IN  MX  10 mail

rtr.s01.as.learn.  IN  A  10.16.1.126
mail.s01.as.learn.  IN  A  10.16.1.100
mailserver      CNAME  mail.s01.as.learn.


EOF
sudo nsd-control-setup


systemctl enable unbound
systemctl start unbound
systemctl restart unbound
systemctl enable nsd
systemctl start nsd
systemctl restart nsd
systemctl restart network

echo "DNS setup is complete."
