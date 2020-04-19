#!/bin/bash

#Based on angristan code: https://github.com/angristan/openvpn-install
function isRoot () {
	if [ "$EUID" -ne 0 ]; then
		return 1
	fi
}
#Final of the agristan code. Thanks!

function checkOS () {
	source /etc/os-release
	echo "Installing openvpn..."
	if [[ -e /etc/debian_version ]]; then 
		apt-get update > /dev/null
		apt-get install -y openvpn > /dev/null
	elif [[ -e /etc/system-release ]]; then
		yum update > /dev/null
		yum install -y openvpn > /dev/null
	elif [[ "$ID" == "fedora" ]]; then
		dnf install -y openvpn > /dev/null
	elif [[ -e /etc/arch-release ]]; then
		pacman -Sy > /dev/null
		pacman --needed --noconfirm -S openvpn > /dev/null
	else
		clear
		echo "Please. Install openvpn package first..."
		exit 1
	fi
	debug
}

function debug () {
	sed -i 's/comp-lzo no/comp-lzo yes/g' $OVPN
	sed -i '/route remote_host 255.255.255.255 net_gateway/d' $OVPN
	echo "tls-version-min 1.0" >> $OVPN
	openvpn $OVPN
	exit 0
}
OVPN=$1
if ! isRoot; then
	echo "Please. Run as root."
	exit 1
elif [ -z $OVPN ]; then
	echo "Please. Specify a file .ovpn"
	exit 1
fi

if [[ -e /usr/sbin/openvpn ]]; then
	debug
else
	checkOS
fi
