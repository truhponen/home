#!/bin/bash

# Run this script as root
# sudo -i
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/1-bootstrap-bare-metal-cluster.sh | bash

echo "This script is based on https://cri-o.io/"
echo "|"
echo "Set variables"
echo "|"

export KUBERNETES_VERSION=v1.30
export CRIO_VERSION=v1.30

echo "|"
echo "Add Kubernetes repository"
echo "|"

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

echo "|"
echo "Add Cri-o repository"
echo "|"

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list

echo "|"
echo "Add Helm repository"
echo "|"

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

echo "|"
echo "Install Kubernetes programs with apt"
echo "|"
apt update
apt install -y cri-o kubelet kubeadm kubectl helm
apt-mark hold cri-o kubelet kubeadm kubectl

echo "|"
echo "Start Cri-o"
echo "|"
systemctl start crio.service

echo "|"
echo "Setup"
echo "|"
swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1

echo "|"
echo "Initialize cluster by running 'kubeadm init --pod-network-cidr=10.244.0.0/16' or join existing cluster with 'kubeadm join 192.168.68.160:6443 --token ...'"
echo "|"
