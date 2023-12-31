#! /bin/bash
### Maven download link ###
# https://maven.apache.org/download.cgi

wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
tar -zxvf apache-maven-3.9.5-bin.tar.gz
sudo mv apache-maven-3.9.5 /opt
### Create Symbolic Link:
# Create a symbolic link to the Maven installation directory. This is optional but can be useful for easily switching between different Maven versions in the future:
sudo ln -s /opt/apache-maven-3.9.5 /opt/maven
export MAVEN_HOME=/opt/apache-maven-3.9.5
export PATH=$PATH:$MAVEN_HOME/bin

mvn -version

### Other easy steps ###
#sudo apt update
#sudo apt install maven
#mvn -version
##Optional: Set MAVEN_HOME:
##It's a good practice to set the MAVEN_HOME environment variable to point to your Maven installation. You can add the following line to your ~/.bashrc or ~/.bash_profile file:
#export MAVEN_HOME=/usr/share/maven
##Optional: Add Maven bin Directory to PATH:
#export PATH=$PATH:$MAVEN_HOME/bin
#source ~/.bashrc
