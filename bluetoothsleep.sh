#!/bin/sh
# Put this file in /usr/lib/systemd/system-sleep
# Follow the the instructions in .blu to apprpriately replace bluetooth_address
# Don't forget to make this file executable!
case $1/$2 in
	pre/*) echo "power off" | bluetoothctl; exit 0
		;;
	post/*) echo "power on" | bluetoothctl; sleep 3s; echo "connect <bluetooth_address>" | bluetoothctl
		;;
esac
