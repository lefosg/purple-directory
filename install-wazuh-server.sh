#!/bin/bash
sudo su

curl -sO https://packages.wazuh.com/4.10/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.10/config.yml

local_ip=$(hostname -I | awk '{print $1}')

sed -i 's/<[^>]*-node-ip>/10.0.20.4/g' config.yml
sed -i 's/<[^>]*-manager-ip>/10.0.20.4/g' config.yml 

bash wazuh-install.sh --generate-config-files
bash wazuh-install.sh -a