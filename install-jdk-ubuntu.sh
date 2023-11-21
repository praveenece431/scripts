!# /bin/bash
### Install JDK8 in Ubuntu ###
### Similarly we can install other versions as well ###

sudo apt update
sudo apt install -y openjdk-8-jdk

# Verify Installation:
java -version

# Set JAVA_HOME (Optional):
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
source ~/.bashrc 
#(or source ~/.bash_profile)

### Update Alternatives (Optional):
#You can also use the update-alternatives command to set the default Java version. If you have multiple Java versions installed, this command allows you to choose the default version
#sudo update-alternatives --config java
