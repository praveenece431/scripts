

#Prerequisites:

1. Ubuntu instance with 4 GB RAM - Master Node - (with ports open to all traffic)
2. Ubuntu instance with at least 2 GB RAM - Worker Node - (with ports open to all traffic)


#int_IP=$(ip r l | head -1 | cut -d' ' -f9)
#sudo hostnamectl set-hostname control-plane
#echo "$int_IP control-plane" | sudo tee -a /etc/hosts
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
#Disable swap memory for better performance
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1


# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
sysctl -p

# Set up the Docker Engine repository
sudo apt-get update 
sudo apt-get update -y  && sudo apt-get install apt-transport-https -y
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

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
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.26.0

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

## In Output you get like below to join the nodes to master:
sudo kubeadm join 10.0.0.4:6443 --token q093mt.3xjjh9kf9sbztx3o \
        --discovery-token-ca-cert-hash sha256:862cbf51f0824af210702502514a156d992fa87762f354a004a9bbbc06fed3c7



# Verify the cluster is working
kubectl get nodes

# Install the Calico network add-on
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

## Command to print the join command.a
kubeadm token create --print-join-command