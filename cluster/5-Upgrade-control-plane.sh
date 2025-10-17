#!/bin/bash

# Run on each node
# Check upgradeable version with 'sudo kubeadm upgrade plan'
# Run this script as root
# sudo -i
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/5-Upgrade-control-plane.sh | bash

####################### UPGRADE KUBEADM #######################

export KUBERNETES_VERSION=v1.31
echo $KUBERNETES_VERSION


# Upgrade Kubernetes repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | 
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list

# Check available kubeadm version
sudo apt update
sudo apt-cache madison kubeadm

# Define latest patch version
export KUBERNETES_PATCH_VERSION='1.31.13-1.1'
echo $KUBERNETES_PATCH_VERSION


# Upgrade kubeadm with apt
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=$KUBERNETES_PATCH_VERSION && \
sudo apt-mark hold kubeadm

# Check Upgrade plan
sudo kubeadm version
sudo kubeadm upgrade plan

# Control plane node
sudo kubeadm upgrade apply $KUBERNETES_PATCH_VERSION\'

# Worker node
sudo kubeadm upgrade node


####################### UPGRADE CRI-O KUBELET KUBECTL #######################

export KUBERNETES_VERSION=v1.31
echo $KUBERNETES_VERSION

export KUBERNETES_DRAIN_NODE=dell-5050-1
echo $KUBERNETES_DRAIN_NODE

export KUBERNETES_DRAIN_NODE=lenovo-m910q 
echo $KUBERNETES_DRAIN_NODE

export KUBERNETES_DRAIN_NODE=dell-7040-1
echo $KUBERNETES_DRAIN_NODE

# On control plane Drain node 
kubectl drain $KUBERNETES_DRAIN_NODE --ignore-daemonsets --delete-emptydir-data


# Upgrade Cri-o repository
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$KUBERNETES_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list


# Check available cri-o version
sudo apt update
sudo apt-cache madison cri-o


# Define latest crio patch version
export CRIO_PATCH_VERSION='1.31.13-1.1'
echo $CRIO_PATCH_VERSION

sudo apt-mark unhold cri-o && \
sudo apt-get update && sudo apt-get install -y cri-o=$CRIO_PATCH_VERSION && \
sudo apt-mark hold cri-o

sudo systemctl daemon-reload
sudo systemctl restart crio


# Define latest Kubernetes patch version
export KUBERNETES_PATCH_VERSION='1.31.13-1.1'
echo $KUBERNETES_PATCH_VERSION


# Upgrade kubelet and kubectl with apt
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=$KUBERNETES_PATCH_VERSION kubectl=$KUBERNETES_PATCH_VERSION && \
sudo apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# On control plane uncordon node
kubectl uncordon $KUBERNETES_DRAIN_NODE

#echo "|"
#echo "Upgrade Kubernetes programs with apt"
#echo "|"

#sudo apt-mark unhold cri-o kubelet kubeadm kubectl && \
#sudo apt-get update && sudo apt-get install -y cri-o=$KUBERNETES_VERSION kubelet=KUBERNETES_PATCH_VERSION kubeadm=KUBERNETES_PATCH_VERSION kubectl=KUBERNETES_PATCH_VERSION && \
#sudo apt-mark hold cri-o kubelet kubeadm kubectl

#echo upgrade cluster with 'sudo kubeadm upgrade apply $KUBERNETES_PATCH_VERSION'
#echo drain nodes with 'kubectl drain NODE'
#systemctl status kubelet
