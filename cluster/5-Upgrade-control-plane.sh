#!/bin/bash

# Run on each node
# Check upgradeable version with 'sudo kubeadm upgrade plan'
# Run this script as root
# sudo -i
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/5%20-%20Upgrade%20control%20plane | bash

echo "|"
echo "Set variables"
echo "|"

export KUBERNETES_VERSION=v1.30
export KUBERNETES_PATCH_VERSION=v1.30.14-*


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

curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

echo "|"
echo "Upgrade kubeadm with apt"
echo "|"

sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=KUBERNETES_PATCH_VERSION && \
sudo apt-mark hold kubeadm

sudo kubeadm version
sudo kubeadm upgrade plan
echo upgrade with 'sudo kubeadm upgrade apply $KUBERNETES_PATCH_VERSION'



#echo drain nodes with 'kubectl drain NODE'

#echo "|"
#echo "Upgrade Kubernetes programs with apt"
#echo "|"

#sudo apt-mark unhold cri-o kubelet kubeadm kubectl && \
#sudo apt-get update && sudo apt-get install -y cri-o=$KUBERNETES_VERSION kubelet=KUBERNETES_PATCH_VERSION kubeadm=KUBERNETES_PATCH_VERSION kubectl=KUBERNETES_PATCH_VERSION && \
#sudo apt-mark hold cri-o kubelet kubeadm kubectl

#echo upgrade cluster with 'sudo kubeadm upgrade apply $KUBERNETES_PATCH_VERSION'
#echo drain nodes with 'kubectl drain NODE'
#systemctl status kubelet
