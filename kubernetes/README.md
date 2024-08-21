# Install Kubernetes in Incus LXC container

1. Change nf_conntrack_max

   Not sure if needed, but was recommended in https://github.com/justmeandopensource/kubernetes/blob/master/lxd-provisioning/README.md

       sudo sysctl -w net.netfilter.nf_conntrack_max=524288

2. Create containers using profile k8s

   Note that key "lxc.apparmor.profile" that is mentioned in most of instruction needs to be "incus.apparmor.profile"

4. Execute shell script

       bash <(curl https://raw.githubusercontent.com/truhponen/home/main/kubernetes/crio-kubernetes.sh)

5. Setup configs

       mkdir -p $HOME/.kube
       sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
       sudo chown $(id -u):$(id -g) $HOME/.kube/config

6. Pod network

       https://kubernetes.io/docs/concepts/cluster-administration/addons/

7. Join workers

       kubeadm join 10.12.96.118:6443 --token 3dy8nl.g3c... \
        --discovery-token-ca-cert-hash sha256:d54...
