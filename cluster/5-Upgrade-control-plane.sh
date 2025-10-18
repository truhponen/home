####################### UPGRADE KUBEADM #######################

export KUBERNETES_REPO_VERSION=v1.33
echo KUBERNETES_REPO_VERSION is $KUBERNETES_REPO_VERSION


# Upgrade Kubernetes repository
echo KUBERNETES_REPO_VERSION is $KUBERNETES_REPO_VERSION
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_REPO_VERSION/deb/Release.key | 
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_REPO_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list


# Check available kubeadm version
sudo apt update
sudo apt-cache madison kubeadm


# Define latest patch version
export KUBERNETES_APT_VERSION='1.33.5-1.1' # with '-1.1'
export KUBERNETES_UPGRADE_VERSION='1.33.5' # without '-1.1'
echo KUBERNETES_APT_VERSION is $KUBERNETES_APT_VERSION
echo KUBERNETES_UPGRADE_VERSION is $KUBERNETES_UPGRADE_VERSION


# Upgrade kubeadm with apt
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=$KUBERNETES_APT_VERSION && \
sudo apt-mark hold kubeadm


# Check Upgrade plan
sudo kubeadm version
sudo kubeadm upgrade plan


# Upgrade control plane node
sudo kubeadm upgrade apply $KUBERNETES_UPGRADE_VERSION

# ... worker node
sudo kubeadm upgrade node


####################### UPGRADE CRI-O KUBELET KUBECTL #######################

# On control plane to drain node 
export KUBERNETES_DRAIN_NODE=dell-5050-1
echo KUBERNETES_DRAIN_NODE is $KUBERNETES_DRAIN_NODE

# ... or
export KUBERNETES_DRAIN_NODE=lenovo-m910q 
echo KUBERNETES_DRAIN_NODE is $KUBERNETES_DRAIN_NODE

# ... or
export KUBERNETES_DRAIN_NODE=dell-7040-1
echo KUBERNETES_DRAIN_NODE is $KUBERNETES_DRAIN_NODE

# On control plane to drain node 
echo KUBERNETES_DRAIN_NODE is $KUBERNETES_DRAIN_NODE
kubectl drain $KUBERNETES_DRAIN_NODE --ignore-daemonsets --delete-emptydir-data


# Upgrade Cri-o repository
echo KUBERNETES_REPO_VERSION is $KUBERNETES_REPO_VERSION
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$KUBERNETES_REPO_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$KUBERNETES_REPO_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list


# Check available cri-o version
sudo apt update
sudo apt-cache madison cri-o


# Define latest crio patch version
export CRIO_APT_VERSION='1.33.5-1.1'
echo CRIO_PATCH_VERSION is $CRIO_APT_VERSION

sudo apt-mark unhold cri-o && \
sudo apt-get update && sudo apt-get install -y cri-o=$CRIO_APT_VERSION && \
sudo apt-mark hold cri-o

sudo systemctl daemon-reload
echo "Systemctl daemon reloaded"
sudo systemctl restart crio
echo "Cri-o restarted"


# Upgrade kubelet and kubectl with apt
echo KUBERNETES_APT_VERSION is $KUBERNETES_APT_VERSION
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=$KUBERNETES_APT_VERSION kubectl=$KUBERNETES_APT_VERSION && \
sudo apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
echo "Systemctl daemon reloaded"
sudo systemctl restart kubelet
echo "Systemctl restarted"


# On control plane uncordon node
echo KUBERNETES_DRAIN_NODE is $KUBERNETES_DRAIN_NODE
kubectl uncordon $KUBERNETES_DRAIN_NODE
