#!/usr/bin/env sh

sudo apt update
sudo apt install -y dnsmasq
cat <<EOF | sudo tee /etc/dnsmasq.conf
# DNS config
server=208.67.222.222
server=208.67.220.220
server=1.1.1.1
listen-address=192.168.0.1
bind-interfaces

# DHCP Config
dhcp-range=192.168.0.50,192.168.0.150,255.255.255.0,12h
dhcp-option=option:router,192.168.0.1
dhcp-option=option:dns-server,192.168.0.1
dhcp-authoritative
EOF

sudo systemctl restart dnsmasq
