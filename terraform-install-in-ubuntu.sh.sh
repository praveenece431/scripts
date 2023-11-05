####################################################
###      Script to install Terraform             ###
####################################################
#! /bin/bash
sudo apt get update
sudo apt update
sudo apt install unzip
## wget https://releases.hashicorp.com/terraform/<VERSION>/terraform_<VERSION>_linux_amd64.zip
echo "*** Get releases from: https://releases.hashicorp.com/terraform/  *** "
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zi
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
