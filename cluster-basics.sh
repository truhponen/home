#!/bin/bash

# Run this script as root
# sudo -i
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/cluster-basics.sh | bash

echo "|"
echo "Install basic programs with apt"
echo "|"
apt update
apt install -y curl wget net-tools
