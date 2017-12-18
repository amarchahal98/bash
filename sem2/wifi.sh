type hostapd
apd_avail=$?

if [[ $apd_avail == 1 ]]; then
  echo "You do not have DHCP installed. It is being installed and configured now."
  yum install -y hostapd
else
  echo "You have HostAPD installed. It will be configured now."

