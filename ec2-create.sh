#!/bin/bash

ec2-create() {
echo "*** This will create one EC2 instance. ****"
sleep 3
keyID=$1
secretID=$2
export AWS_ACCESS_KEY_ID=$keyID
export AWS_SECRET_ACCESS_KEY=$secretID
export AWS_DEFAULT_REGION=us-east-1
aws ec2 create-key-pair --key-name aws-login --query 'KeyMaterial' --output text > aws-login.pem
chmod 400 aws-login.pem
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault, Values=true" --query 'Vpcs[0].VpcId' --output text)
SUB_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query 'Subnets[0].SubnetId' --output text)
aws ec2 run-instances --image-id ami-06aa3f7caf3a30282 --count 1 --instance-type t2.medium --key-name aws-login --subnet-id "$SUB_ID"
}

ec2-create $1 $2
