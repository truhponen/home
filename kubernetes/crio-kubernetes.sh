#!/bin/bash

echo "This script is based on https://cri-o.io/"
echo "|"
echo "Set variables"
echo "|"

KUBERNETES_VERSION=v1.30
CRIO_VERSION=v1.30

echo "|"
echo "Add Kubernetes repository"
echo "|"

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

echo "|"
echo "Add Cri-o repository"
echo "|"
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

echo "|"
echo "Install Kubernetes packages"
echo "|"
apt update
apt install -y cri-o kubelet kubeadm kubectl

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
echo "Init"
echo "|"
kubeadm init
