#!/bin/bash

# Run this script as root
# sudo -i
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/0-cluster-basics.sh | bash

echo "|"
echo "Install basic programs with apt"
echo "|"
apt update
apt install -y git gpg wget net-tools

echo "|"
echo "Install Git-secret"
echo "|"
sh -c "echo 'deb https://gitsecret.jfrog.io/artifactory/git-secret-deb git-secret main' >> /etc/apt/sources.list"
wget -qO - 'https://gitsecret.jfrog.io/artifactory/api/gpg/key/public' | sudo apt-key add -
apt update
apt install -y git-secret

echo "|"
echo "Testing, that it worked"
echo "|"
git secret --version
