# Install Kubernetes in Incus LXC container

1. Change nf_conntrack_max

   Not sure if needed, but was recommended in https://github.com/justmeandopensource/kubernetes/blob/master/lxd-provisioning/README.md. I had troubles with kube-proxy giving error related "Set sysctl" entry="net/netfilter/nf_conntrack_max" value=131072: not permitted. This was before I changed "lxc.apparmor.profile" to "incus.apparmor.profile"

       sudo sysctl -w net.netfilter.nf_conntrack_max=524288

2. Create containers using profile [k8s](https://github.com/truhponen/home/blob/main/incus/k8s)

   Note that key "lxc.apparmor.profile" that is mentioned in most of instruction needs to be "incus.apparmor.profile"

3. After container started add profile [k8s-for-testflight](https://github.com/truhponen/home/blob/main/incus/k8s-for-testflight)
   
   Without profile's device mappings, at least, testflight will fail. Device mappings were copied from https://microk8s.io/docs/install-lxd.

5. Install http-utils

       apt update
       apt install -y software-properties-common curl

5. Execute shell script

       bash <(curl https://raw.githubusercontent.com/truhponen/home/main/kubernetes/install-in-Incus-LXC/crio-kubernetes.sh)

   Init has flag `--pod-network-cidr=10.244.0.0/16` for Flannel

7. Setup configs

       mkdir -p $HOME/.kube
       sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
       sudo chown $(id -u):$(id -g) $HOME/.kube/config

8. Install Helm

       curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
       sudo apt-get install apt-transport-https --yes
       echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
       apt update
       apt install helm
  
10. Pod network

       https://kubernetes.io/docs/concepts/cluster-administration/addons/

11. Join workers

       kubeadm join 10.12.96.118:6443 --token 3dy8nl.g3c... \
        --discovery-token-ca-cert-hash sha256:d54...
