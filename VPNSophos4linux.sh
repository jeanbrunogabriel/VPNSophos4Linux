#!/bin/bash

#Functions isRoot and checkOS are based on angristan code: https://github.com/angristan/openvpn-install thanks!

function isRoot () {
	if [ "$EUID" -ne 0 ]; then
		return 1 
	fi
	
}
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
	TLS=$(! grep tls-version-min $OVPN && sed -i '$ a tls-version-min 1.0' $OVPN || sed -i 's/tls-version-min *.*/tls-version-min 1.0/g' $OVPN)
	openvpn $OVPN
	exit 0
}
function requirements () {
	if ! isRoot; then
		echo "ERROR: Please. Run as root."
		exit 1
	elif [[ -z $OVPN || $(echo $OVPN | grep -v .ovpn$) ]]; then
		echo "ERROR: Please. Specify a file .ovpn"
		exit 1
	elif [[ ! -e $OVPN ]]; then
		echo "ERROR: This file does not exists"
		exit 1
	fi
	return
}
OVPN=$1
requirements 
if  [[ ! -e /usr/sbin/openvpn ]]; then
	checkOS
fi
	debug 


