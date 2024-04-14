# Kubernetes Setup Guide

## Prerequisites

1. Ubuntu instance with 4 GB RAM - Master Node - (with ports open to all traffic)
2. Ubuntu instance with at least 2 GB RAM - Worker Node - (with ports open to all traffic)

## Installation Steps

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Set up the Docker Engine repository
sudo apt-get update 
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Add Docker’s official GPG key

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Update the apt package index
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose
# Add your 'cloud_user' to the docker group
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker azureuser
newgrp docker
sudo chmod 777 /var/run/docker.sock

# On all nodes, install kubeadm, kubelet, and kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
sudo apt-mark hold kubelet kubeadm kubectl

#(Optional) Enable the kubelet service before running kubeadm:
sudo systemctl enable --now kubelet

# On the control plane node only, initialize the cluster and set up kubectl access
#sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.26.0
sudo kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Verify the cluster is working
kubectl get nodes

# Install the Calico network add-on
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

##
sudo kubeadm join 10.0.0.4:6443 --token q093mt.3xjjh9kf9sbztx3o \
        --discovery-token-ca-cert-hash sha256:862cbf51f0824af210702502514a156d992fa87762f354a004a9bbbc06fed3c7

## kubeadm token create --print-join-command
