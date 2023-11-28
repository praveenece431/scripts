#!/bin/bash

usage() {
  echo "Usage: $0 keyID secretID"
    exit 1
 }

if [ $# -ne 2 ]; then
  usage
fi

ec2-create() {
echo "*** This will create one EC2 instance. ****"
sleep 3
keyID=$1
secretID=$2
export AWS_ACCESS_KEY_ID=$keyID
export AWS_SECRET_ACCESS_KEY=$secretID
export AWS_DEFAULT_REGION=us-east-1
echo "*** Deleting the previous PEM key file in local ***"
rm -f aws-login.pem
KEY=$(aws ec2 describe-key-pairs --query 'KeyPairs[*].[KeyName]' --output text) || true
aws ec2 delete-key-pair --key-name $KEY || true
aws ec2 create-key-pair --key-name aws-login --query 'KeyMaterial' --output text > aws-login.pem
chmod 400 aws-login.pem
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault, Values=true" --query 'Vpcs[0].VpcId' --output text)
SUB_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query 'Subnets[0].SubnetId' --output text)
aws ec2 run-instances --image-id ami-06aa3f7caf3a30282 --count 1 --instance-type t2.medium --key-name aws-login --subnet-id "$SUB_ID" --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=POC}]'
}

eks-spun-remote() {
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
curl -LO https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl
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

eks-create() {
echo "*** Waiting for the PUBLIC IP. This may take up to 20 seconds ****"
sleep 12
pubIP=$(aws ec2 describe-instances --query 'Reservations[].Instances[].PublicIpAddress' --output text)
echo "*** Public IP received: $pubIP ***"
#ssh -i aws-login.pem ubuntu@$pubIP -t 'bash -s' < eks-spun-remote $1 $2
#ssh -i aws-login.pem ubuntu@$pubIP -t 'eks-spun-remote $1 $2'
}

ec2-create $1 $2
#eks-create $1 $2

