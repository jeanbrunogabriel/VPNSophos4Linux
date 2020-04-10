#!/bin/bash

sed -i 's/comp-lzo no/comp-lzo yes/g' $1
sed -i '/route remote_host 255.255.255.255 net_gateway/d' $1
openvpn $1
