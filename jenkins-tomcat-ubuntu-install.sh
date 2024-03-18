#! /usr/bin/bash
echo "*** Installing JDK 11, Tomcat, Jenkins ***"
sudo apt update
sudo apt install openjdk-11-jdk
wget https://get.jenkins.io/war-stable/latest/jenkins.war
https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.87/bin/apache-tomcat-9.0.87.tar.gz
tar -xvf apache-tomcat-9.0.87.tar.gz
mv apache-tomcat-9.0.87 tomcat
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
sudo mv jenkins.war tomcat/webapps/
./tomcat/bin/startup.sh
echo "############################################################"
echo "############  Access Jenkins from the url   ################"
echo "############ http://<IP address>:8080/jenkins ##############"
echo "############################################################"
