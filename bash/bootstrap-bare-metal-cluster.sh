#!/bin/bash

# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/bash/kubernetes-crio-flannel.sh | bash

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
echo "Install Kubernetes packages"
echo "|"
apt update
apt install -y cri-o kubelet kubeadm kubectl helm
apt-mark hold cri-o kubelet kubeadm kubectl helm

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
kubeadm init --pod-network-cidr=10.244.0.0/16

echo "|"
echo "Install Cluster basic programs for Cluster Helm"

echo "|"
echo "Install Flannel container networking with Helm"
echo "|"
kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged
helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="10.244.0.0/16" --namespace kube-flannel flannel/flannel

echo "|"
echo "Install PureLB bare metal loadbalancer with Helm"
echo "|"
helm repo add purelb https://gitlab.com/api/v4/projects/20400619/packages/helm/stable
helm repo update
helm install --create-namespace --namespace=purelb purelb purelb/purelb

echo "|"
echo "Apply IP range for PureLB with ServiceGroup"
echo "|"
kubectl apply -f https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/purelb/servicegroup.yaml -n purelb


echo "|"
echo "Install Traefik Ingress controller with Helm and customizations"
echo "|"
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install -f https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/traefik/helm.yaml traefik traefik/traefik --create-namespace -n traefik
