#!/bin/bash

# Run this script as root
# sudo -i
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/0-cluster-basics.sh | bash

echo "|"
echo "Add Git-secret repository"
echo "|"
curl -fsSL https://gitsecret.jfrog.io/artifactory/api/gpg/key/public | gpg --dearmor -o /etc/apt/keyrings/git-secret-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/git-secret-apt-keyring.gpg] https://gitsecret.jfrog.io/artifactory/git-secret-deb git-secret main" | tee /etc/apt/sources.list.d/git-secret.list

echo "|"
echo "Install basic programs with apt"
echo "|"
apt update
apt install -y gpg git git-secret wget net-tools nfs-common

echo "|"
echo "Testing Git-secret - this should show version"
echo "|"
git secret --version
