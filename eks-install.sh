#! /bin/bash

echo "*** Script to install EKS. Prerequisite is to have the aws credentils do authenticate with CLi by doing aws configure ***"

echo "*** Install AWS CLI V2 ***"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
echo "*** Check the aws cli version ***"
aws --version

echo "*** Install KUBECTL CLI ***"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
#chmod +x ./kubectl
#mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo "*** Check KUBECTL Version ***"
kubectl version --short --client

echo "*** Download EKSCTL ***"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin
echo "*** check version ***"

echo "*** provisioning EKS cluster. This will take up to 10 min.. plese wait ... ***"
eksctl create cluster --name dev --region us-east-1 --zones us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1f --nodegroup-name standard-workers --node-type t3.medium --nodes 2 --nodes-min 1 --nodes-max 4 --managed

eksctl get cluster
aws eks update-kubeconfig --name dev --region us-east-1
