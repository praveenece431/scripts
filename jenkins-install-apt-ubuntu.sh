#! /usr/bin/bash

echo "##### Install Jenkins with apt package manager ########"
sudo apt update
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt install openjdk-8-jre
# set default version as Java 8 below
sudo update-alternatives --config java
java -version
sudo apt install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
