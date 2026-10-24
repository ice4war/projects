#!/usr/bin/env sh

sudo apt-get update
sudo apt-get install -y dnsmasq
cat <<EOF | sudo tee /etc/dnsmasq.conf
# DNS config
server=208.67.222.222
server=208.67.220.220
server=1.1.1.1
listen-address=192.168.1.65
bind-interfaces

# DHCP Config
dhcp-range=192.168.1.70,192.168.1.100,255.255.255.192,12h
dhcp-option=option:router,192.168.1.65
dhcp-option=option:dns-server,192.168.1.65
dhcp-authoritative
EOF

sudo systemctl restart dnsmasq
