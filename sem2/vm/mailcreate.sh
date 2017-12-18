#!/bin/bash

name=mail

vboxmanage createvm --name $name --ostype "RedHat_64" --register
vboxmanage modifyvm $name --memory 4096 --vram 128 > /dev/null 2>&1

vboxmanage storagectl $name --name "IDE Controller" --add ide > /dev/null 2>&1
vboxmanage storageattach $name --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /home/achahal/scripts/test/mailvm.iso > /dev/null 2>&1
vboxmanage storageattach $name --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso > /dev/null 2>&1

vboxmanage createhd --filename ~/VirtualBox\ VMs/$name/$name.vdi --size 20480 > /dev/null 2>&1

vboxmanage storageattach $name --storagectl "IDE Controller" --port 1 --device 0 --type hdd --medium ~/VirtualBox\ VMs/$name/$name.vdi > /dev/null 2>&1

vboxmanage modifyvm $name --nic1 nat --nicpromisc1 allow-all --nictype2 virtio > /dev/null 2>&1

vboxmanage modifyvm $name --macaddress1 0800277228AC > /dev/null 2>&1
VBoxManage startvm mail

sleep 5


until [[ $myvar == 0 ]]
do
	VBoxManage modifyvm mail --nic1 intnet --intnet1 as_net --nicpromisc1 allow-all --nictype1 virtio > /dev/null 2>&1
	myvar=$?
done
echo "Modified Network Settings"


