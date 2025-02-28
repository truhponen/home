#!/bin/bash

# Run this script as kubernetes maintainer user
# curl https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/2-add-cluster-applications.sh | bash

echo "|"
echo "Make user configurations"
echo "|"

kubeadm alpha phase kubeconfig admin --kubeconfig-dir /etc/kubernetes --cert-dir /etc/kubernetes/pki

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "|"
echo "Install Cluster basic programs with Helm"

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
helm install - https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/purelb/helm-customization.yaml --create-namespace --namespace=purelb purelb purelb/purelb

echo "|"
echo "Install Traefik Ingress controller with Helm and customizations"
echo "|"
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install -f https://raw.githubusercontent.com/truhponen/home/refs/heads/main/cluster/traefik/helm-customization.yaml --create-namespace --namespace=traefik traefik traefik/traefik

echo "|"
echo "Install CSI-driver NFS with Helm"
echo "There might be errors as instructions install CSI to kube-system namespace"
echo "|"
helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm repo update
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --create-namespace --namespace=csi-driver-nfs --version v4.10.0
