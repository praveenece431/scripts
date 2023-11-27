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

aws-cli-install() {
sudo apt update
sudo apt install -y awscli
aws --version
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
sudo apt update
sudo apt install openjdk-11-jdk
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar -xf apache-maven-3.8.6-bin.tar.gz
export M2_HOME=/path/to/apache-maven-3.8.6
export PATH=$M2_HOME/bin:$PATH
mvn -version
}

helm-install() {
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
}

docker-install() {
### Docker installation steps in Ubuntu ###
sudo apt update
# Install Prerequisites:
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
# Add Docker's official GPG key to verify the integrity of the packages.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Add the Docker stable repository to your system.
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Update the package list with the new Docker repository.
sudo apt update
# Install the Docker engine.
sudo apt install -y docker-ce docker-ce-cli containerd.io
# Start docker service
sudo systemctl start docker
# Enable Docker to start on boot.
sudo systemctl enable docker
# Add Your User to the Docker Group (Optional, but recommended for using Docker without sudo):
#sudo usermod -aG docker <your-username>
sudo usermod -aG docker ubuntu
# Verify docker version
docker --version
}

#### Calling functions #######
az-cli-ubuntu
aws-cli-install
kubectl-ubuntu
helm-install
maven-install

