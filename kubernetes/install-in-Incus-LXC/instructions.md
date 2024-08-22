# Install Kubernetes in Incus LXC container

1. Change nf_conntrack_max

   Not sure if needed, but was recommended in https://github.com/justmeandopensource/kubernetes/blob/master/lxd-provisioning/README.md. I had troubles with kube-proxy giving error related "Set sysctl" entry="net/netfilter/nf_conntrack_max" value=131072: not permitted. This was before I changed "lxc.apparmor.profile" to "incus.apparmor.profile"

       sudo sysctl -w net.netfilter.nf_conntrack_max=524288

2. Create containers using profile [k8s](https://github.com/truhponen/home/blob/main/incus/k8s)

   Note that key "lxc.apparmor.profile" that is mentioned in most of instruction needs to be "incus.apparmor.profile"

3. Add also profile [k8s-for-testflight](https://github.com/truhponen/home/blob/main/incus/k8s-for-testflight) (not sure if needed)

   Those were copied from https://microk8s.io/docs/install-lxd as I had troubles with kube-proxy giving error related "Set sysctl" entry="net/netfilter/nf_conntrack_max" value=131072: not permitted. This was before I changed "lxc.apparmor.profile" to "incus.apparmor.profile"

5. Install http-utils

       apt update
       apt install -y software-properties-common curl

5. Execute shell script

       bash <(curl https://raw.githubusercontent.com/truhponen/home/main/kubernetes/install-in-Incus-LXC/crio-kubernetes.sh)

6. Setup configs

       mkdir -p $HOME/.kube
       sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
       sudo chown $(id -u):$(id -g) $HOME/.kube/config

7. Pod network

       https://kubernetes.io/docs/concepts/cluster-administration/addons/

8. Join workers

       kubeadm join 10.12.96.118:6443 --token 3dy8nl.g3c... \
        --discovery-token-ca-cert-hash sha256:d54...
