#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error

echo "Installing base packages"
yum -y update
echo "group_package_types=mandatory,default,optional" >> /etc/yum.conf
yum -y group install base

echo "Installing the Extra Packages for Enterprise Linux Repository" 
yum -y install epel-release
yum -y update

echo "Installing project specific tools"
yum -y install curl vim wget tmux nmap-ncat tcpdump nmap git

echo "Setting Up VirtualBox Guest Additions"
echo "Installing pre-requisities"
yum -y install kernel-devel kernel-headers dkms gcc gcc-c+

echo "Creating mount point, mounting, and installing VirtualBox Guest Additions"
mkdir vbox_cd
mount /dev/cdrom ./vbox_cd
./vbox_cd/VBoxLinuxAdditions.run
umount ./vbox_cd
rmdir ./vbox_cd

echo "Disabling selinux"
setenforce 0
sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config

echo "Turning off and disabling Network Manager"
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service

echo "Turning off and disabling Firewall Daemon"
systemctl stop firewalld.service
systemctl disable firewalld.service

echo "Enabling and starting the Network Service (ignoring angry messages)"
systemctl enable network.service 
systemctl start network.service

echo "Enable sshd"
systemctl enable sshd.service
systemctl start sshd.service

echo "Setting up Instructor User"
useradd -m -G wheel,users instructor
echo "instructor ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
mkdir ~instructor/.ssh/
cat > ~instructor/.ssh/authorized_keys <<EOF
ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACbbA/5CA4Z5AhmOX4JMyxqXIh7JwR7B6S0DOFCj4k8Y8255K/bGXWw5tFWokSCi+89wnj7Y5AIrEnhMo9Pp2y3iQG21hFs+Ba0KI7cSL73X4bUBhLy1EUZjo5wNcPTNG1YgG94a9iTIoqUtoZLRiDvmPMvNR929dOTD5UEA3t3wy2XXg== nasp@milkplus
EOF
chown -R instructor:instructor ~instructor/.ssh

