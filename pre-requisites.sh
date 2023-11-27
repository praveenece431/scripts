#!/bin/bash

az-cli-centOs() {
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
yum install azure-cli
az --version
}

az-cli-ubuntu() {
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

kubectl-ubuntu() {
sudo apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl
echo 'source <(kubectl completion bash)' >> ~/.bashrc
}

maven-install() {
yum install java-1.8.0-openjdk-devel.x86_64
mkdir /opt/maven
cd /opt/maven
#downloading maven version 3.6.0
wget --no-check-certificate "https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz"
tar -xvf /opt/maven/apache-maven-3.8.5-bin.tar.gz
mv apache-maven-3.8.5 maven
}

helm-install() {
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
}

