#! /bin/bash

sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz
#Usually, you would have a disk mounted to the data directory. For this tutorial, I will simply create a /data directory. Also, you need a folder for Prometheus configuration files.
sudo mkdir -p /data /etc/prometheus
cd prometheus-2.47.1.linux-amd64/
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
cd
rm -rf prometheus-2.47.1.linux-amd64.tar.gz
# Check prometheus Version
prometheus --version
sudo systemctl enable prometheus
sudo systemctl start prometheus
## Refer below link for config:
# https://mrcloudbook.hashnode.dev/devsecops-netflix-clone-ci-cd-with-monitoring-email


