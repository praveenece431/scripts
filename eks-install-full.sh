#!/usr/bin/bash

usage() {
  echo "Usage: $0 keyID secretID"
  exit 1
}

if [ $# -ne 2 ]; then
usage
fi

eks-install() {
echo "*** Provisioning eks cluster *****"
keyId="$1"
secretKey="$2"
sudo apt update
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
aws --version
export AWS_ACCESS_KEY_ID="$keyId"
export AWS_SECRET_ACCESS_KEY="$secretKey"
export AWS_DEFAULT_REGION=us-east-1
sudo apt  install docker.io -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
kubectl version --short --client
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin
eksctl version
echo "***** Provisioning EKS cluster now. This will take upto 15 min ***** "
eksctl create cluster --name dev --region us-east-1 --zones us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1f --nodegroup-name standard-workers --node-type t3.medium --nodes 2 --nodes-min 1 --nodes-max 4 --managed
eksctl get cluster
aws eks update-kubeconfig --name dev --region us-east-1
kubectl create ns poc
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "*** Creating a POC namespace ***"
kubectl create ns poc
echo "**** Install Istio ****"
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.17.1/bin
sudo mv istioctl /usr/local/bin/
istioctl install -y
kubectl label namespace poc  istio-injection=enabled --overwrite
helm version -o short
kubectl version --short --client
#kubectl version -o short
echo "**************************"
echo -e "export AWS_ACCESS_KEY_ID=$1"
echo -e "export AWS_SECRET_ACCESS_KEY=$2"
echo -e 'export AWS_DEFAULT_REGION=us-east-1'
}

eks-install $1 $2
