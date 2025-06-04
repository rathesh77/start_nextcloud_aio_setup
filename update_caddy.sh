#!/bin/bash


sudo cp -r ./caddy/* /etc/caddy/
sudo rm -rf /var/lib/caddy/.local/share/caddy
sudo service caddy restart