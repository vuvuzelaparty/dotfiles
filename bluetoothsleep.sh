#!/bin/sh
# Put this file in /lib/systemd/system-sleep
# Follow the the instructions in .blu to apprpriately replace bluetooth_address
# Don't forget to make this file executable!
case $1/$2 in
	pre/*) exit 0
		;;
	post/*) echo "power on" | bluetoothctl; sleep 3s; echo "connect <bluetooth_address>" | bluetoothctl
		;;
esac
