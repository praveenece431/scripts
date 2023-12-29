## Install Node Exporter

sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo mv \
  node_exporter-1.6.1.linux-amd64/node_exporter \
  /usr/local/bin/
rm -rf node_exporter*
node_exporter --version
node_exporter --help

# Follow this manually
echo 'sudo vim /etc/systemd/system/node_exporter.service'
## Refer below link for config:
#https://mrcloudbook.hashnode.dev/devsecops-netflix-clone-ci-cd-with-monitoring-email
echo 'Refer: https://mrcloudbook.hashnode.dev/devsecops-netflix-clone-ci-cd-with-monitoring-email'

