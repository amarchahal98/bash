hostnamectl set-hostname "rtr.s01.as.learn"

rm -f /etc/sysconfig/network-scripts/ifcfg-*

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
BOOTPROTO=none
ONBOOT=yes
DEVICE=eth0
TYPE=Ethernet
NAME=eth0
IPADDR=10.16.255.1
PREFIX=24
GATEWAY=10.16.255.254
DNS1=142.232.221.253

EOF

cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOF
BOOTPROTO=none
ONBOOT=yes
TYPE=Ethernet
NAME=eth1
DEVICE=eth1
IPADDR=10.16.1.126
PREFIX=25
DEFROUTE=no

cat > /etc/sysconfig/network-scripts/ifcfg-wlp0s11u2 << EOF
DEVICE="wlp0s11u2"
BOOTPROTO=none
TYPE="Wireless"
ONBOOT=yes
NM_CONTROLLED=no
IPADDR=10.16.1.129
PREFIX=25
ESSID="NASP19_S01"
CHANNEL="11"
MODE="Master"
RATE="Auto"

EOF
