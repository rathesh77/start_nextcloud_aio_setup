#!/bin/bash

# flush and clear/delete ALL the rules. 

sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -F
sudo iptables -X

# allow localhost only to the ports
sudo iptables -A INPUT -p tcp -s 127.0.0.1 --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp -s 127.0.0.1 --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p tcp -s 127.0.0.1 --dport 11000 -j ACCEPT

# block the rest
sudo iptables -A INPUT -p tcp --dport 443 -j DROP
sudo iptables -A INPUT -p tcp --dport 8080 -j DROP  
sudo iptables -A INPUT -p tcp --dport 11000 -j DROP

# sudo iptables -I DOCKER-USER -j DROP

sudo netfilter-persistent save
