#!/bin/bash
# A script to set a wlan interface to monitor mode

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
#trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT
trap exit_on_error EXIT

exit_on_error() {
    exit_code=$?
    #last_command=${last_command}
    if [ $exit_code -ne 0 ]; then
        >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
    else
        echo "$0 Finished successfully"
    fi
    exit $exit_code
}

use_ifconfig=no

if [ $# -eq 0 ]
  then
    #Just output current devices
    echo "No Device Specified - Showing Current Wireless Config"
    #iwconfig
    ip link show
    iw dev
    #iw list
    exit 0
fi

#for some reason, using ifconfig/iwconfig results in very poor packet performance on the rtl8812au
# see https://github.com/aircrack-ng/rtl8812au
# see https://wireless.wiki.kernel.org/en/users/documentation/iw

if [[ $use_ifconfig == yes ]]
  then
    echo "using ifconfig/iwconfig"
    sudo ifconfig $1 down
    sudo iwconfig $1 mode monitor
    sudo ifconfig $1 up
    sudo iwconfig $1 channel 6
  else
    echo "using ip/iw"
    sudo ip link set $1 down
    sudo iw dev $1 set type monitor
    sudo ip link set $1 up
    sudo iw dev $1 set channel 6
fi
    


echo "Monitor mode enabled for $1"
if [[ $use_ifconfig == yes ]]
  then
    iwconfig $1
  else
    ip link show dev $1
    iw dev $1 info
fi

#sudo tshark --interface wlan1 --monitor-mode -f "broadcast or multicast"
#sudo airodump-ng --beacons --ht20 --channel 6  wlan1 
#sudo airodump-ng --beacons --ht20 --channel 6 -w wlan12022-12-21.pcap --output-format pcap,logcsv  wlan1
