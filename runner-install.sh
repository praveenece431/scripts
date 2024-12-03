### Script to install and register runner in Gitlab ###

#!/bin/bash

# Install Docker if not already installed (for Ubuntu-based systems)
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  sudo apt update
  sudo apt install -y docker.io jq
  sudo systemctl start docker
  sudo systemctl enable docker
fi

# Check if gitlab-runner is already installed
if ! command -v gitlab-runner &> /dev/null; then
  echo "Installing GitLab Runner..."
  # Download the binary for your system
  sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

  # Give it permission to execute
  sudo chmod +x /usr/local/bin/gitlab-runner

  # Create a GitLab Runner user
  sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

  # Install and run as a service
  sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
else
  echo "GitLab Runner is already installed. Skipping installation."
fi

# Register the runner
User_Token='<User token>'
Group_ID='<GroupID>'
export Executors='10'
TagList='docker,linux'

echo "** Executors provided are $Executors"

GITLAB_URL='https://gitlab.com/api/v4/user/runners'
TOKEN=$(curl --silent --request POST --url $GITLAB_URL  \
         --data "runner_type=group_type"   \
         --data "group_id=$Group_ID"   \
         --data "description=Azure runner" \
         --data "tag_list=$TagList"   \
         --header "PRIVATE-TOKEN: $User_Token" | jq -r .token)

# Check if the runner is already registered
# if ! gitlab-runner list &> /dev/null; then
  echo "Registering GitLab Runner..."
  gitlab-runner register --non-interactive --url "https://gitlab.com/" \
         --registration-token "$TOKEN" \
         --name "RNDS AZURE Linux Runner" \
         --tag-list "$TagList"  \
         --executor "docker" \
         --docker-image docker:stable \
         --docker-pull-policy if-not-present \
         --locked=false \
         --docker-privileged=false \
         --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
         --request-concurrency 10 \
         --limit 10
# else
  echo "GitLab Runner is already registered. Skipping registration."
# fi

# Update concurrency settings
sed -i "s/concurrent = 1/concurrent = $Executors/g" /etc/gitlab-runner/config.toml

# Ensure Docker socket permissions
chmod 777 /var/run/docker.sock

# Restart the GitLab Runner service
gitlab-runner restart
