#!/bin/bash

sed -i 's/comp-lzo no/comp-lzo yes/g' $1
sed -i 's/route remote_host//g*' $1
openvpn $1 
