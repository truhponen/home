## Incus preparation for Kubernetes

1. Change nf_conntrack_max

From https://github.com/justmeandopensource/kubernetes/blob/master/lxd-provisioning/README.md

       sudo sysctl -w net.netfilter.nf_conntrack_max=524288

2. Create containers using profile k8s

3. When container is running add profile k8s-testflite. Otherwise testflite fails.

4. Execute shell script

       bash < (curl https://raw.githubusercontent.com/truhponen/home/main/kubernetes/crio-kubernetes.sh)
