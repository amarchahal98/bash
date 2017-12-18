#!/bin/bash
#===============================================================================
#=============================VARIABLES=========================================
#===============================================================================

name=router

#===============================================================================
#===============================VM CREATION=====================================
#===============================================================================

echo "Creating Virtual Machine..."

VBoxManage createvm --name $name  --ostype "RedHat_64" --register
VBoxManage modifyvm $name --memory 4096 --vram 128 > /dev/null 2>&1
VBoxManage storagectl $name --name "IDE Controller" --add ide > /dev/null 2>&1
VBoxManage storageattach $name --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /home/achahal/scripts/test/works.iso > /dev/null 2>&1
VBoxManage storageattach $name --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso > /dev/null 2>&1
VBoxManage createhd --filename ~/VirtualBox\ VMs/$name/$name.vdi --size 20480 > /dev/null 2>&1
VBoxManage storageattach $name --storagectl "IDE Controller" --port 1 --device 0 --type hdd --medium ~/VirtualBox\ VMs/$name/$name.vdi > /dev/null 2>&1
vboxmanage modifyvm router --usb on > /dev/null 2>&1
vboxmanage usbfilter add 0 --target "router" --name usbstick --vendorid 0x0cf3 --productid 0x9271 > /dev/null 2>&1
VBoxManage modifyvm $name --nic1 nat --nicpromisc1 allow-all --nictype1 virtio > /dev/null 2>&1
VBoxManage modifyvm $name --macaddress1 auto > /dev/null 2>&1
VBoxManage modifyvm $name --macaddress2 auto > /dev/null 2>&1

#===============================================================================
#===========================VM MODIFICATION=====================================
#===============================================================================
sleep 5
VBoxManage startvm router

echo "Virtual Machine created."
echo "Starting VM."

until [[ $myvar == 0 ]];
do
	VBoxManage modifyvm router --nic1 bridged --bridgeadapter1 VLAN2016 --nicpromisc1 allow-all --nictype1 virtio > /dev/null 2>&1 > /dev/null && VBoxManage modifyvm router --nic2 intnet --intnet2 as_net --nicpromisc2 allow-all --nictype2 virtio > /dev/null 2>&1
	myvar=$?
	sleep 5
done

echo "Changing Network Settings from NAT to Bridged."

#===============================================================================
#============================SSH CONNECTION=====================================
#===============================================================================

echo "Starting VM and enabling SSH connection..."
vboxmanage startvm router
until [[ $var == 0 ]]
do
	echo "Trying SSH now..."
	sleep 15
	scp -rp ~/scripts/test/updaterepo/ achahal@10.16.255.1:/home/achahal/ > /dev/null 2>&1
	var=$?
done
echo "SSH File Transfer Complete."
echo "Executing script now..."
ssh achahal@10.16.255.1 'sudo bash /home/achahal/updaterepo/execute.sh'
echo "Script execution complete."
echo "RTR setup is complete."

vboxmanage startvm mail 
until [[ $ssh1 == 0 ]]
do
        echo "Attempting SSH Connection... Retrying." 
        sleep 15
        scp -rp ~/scripts/test/updaterepo/ achahal@10.16.1.100:/home/achahal/ > /dev/null 2>&1
        ssh1=$?
done
echo "SSH Complete."
echo "Executing scripts now..."
ssh achahal@10.16.1.100 'chmod +x /home/achahal/updaterepo/mailexecute.sh'
ssh achahal@10.16.1.100 'sudo bash /home/achahal/updaterepo/mailexecute.sh'
