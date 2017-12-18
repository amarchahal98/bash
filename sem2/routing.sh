#Install the packages if required

type ospfd
qua_avail=$?

if [[ qua_avail == 1 ]]; then
  echo "You do now have quagga installed. It will be installed now."
  yum install -y quagga
else
  echo "You already have quagga installed. Configuring now."

fi
rm -f /etc/quagga/ospfd.conf
touch /etc/quagga/ospfd.conf
chown quagga:quagga /etc/quagga/ospfd.conf

#Adds the required config 
cat > /etc/quagga/ospfd.conf << EOF
hostname ospfd
password zebra
log stdout
interface eth0
interface eth1
interface lo
router ospf
        ospf router-id 10.16.255.1
        network 10.16.1.0/25 area 0.0.0.0
	network 10.16.1.128/25 area 0.0.0.0
        network 10.16.255.0/24 area 0.0.0.0
line vty
EOF
#Configure Services
systemctl enable zebra
systemctl enable ospfd
systemctl start zebra
systemctl start ospfd

echo -e "QUAGGA is configured on `hostname`.\n"

echo -e "Showing IP Routing Tables now:\n\n"
echo 1 > /proc/sys/net/ipv4/ip_forward
cat /proc/sys/net/ipv4/ip_forward
ip route show
