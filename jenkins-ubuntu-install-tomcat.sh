## Install jenkins in Tomcat

# Prompt
#Act as a DevOps engineer with expertise in Linux, jenkins and Maven. You are given a task to install Jenkins in Ubunti 22.xx version in the below mentioned method:

#1. Install Tomcat.
#2. Download Jenkins.war file
#3. Deploy in Tomcat webapps
#4. Start the tomcat service
#5. Access the Jenkins app on port 8080.

# Update system packages
sudo apt update

# Install Tomcat
sudo apt install tomcat9

# Download Jenkins WAR file
wget https://get.jenkins.io/war-stable/latest/jenkins.war

# Move Jenkins WAR file to Tomcat webapps
sudo mv jenkins.war /var/lib/tomcat9/webapps/

# Start Tomcat
sudo systemctl start tomcat9

# Enable Tomcat to start at boot
sudo systemctl enable tomcat9
