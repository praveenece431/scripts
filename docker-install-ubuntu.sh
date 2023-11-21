### Docker installation steps in Ubuntu ###
sudo apt update
# Install Prerequisites:
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
# Add Docker's official GPG key to verify the integrity of the packages.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Add the Docker stable repository to your system.
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list with the new Docker repository.
sudo apt update

# Install the Docker engine.
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start docker service
sudo systemctl start docker

# Enable Docker to start on boot.
sudo systemctl enable docker

# Add Your User to the Docker Group (Optional, but recommended for using Docker without sudo):
#sudo usermod -aG docker <your-username>
sudo usermod -aG docker ubuntu

# Verify docker version
docker --version
