#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y update
sudo apt-get -y upgrade

# install basic tools
sudo apt-get install -y zip unzip
sudo apt-get install -y openssl-devel
sudo apt-get install -y libffi-devel
sudo apt-get install -y wget

# for eventual scripts
sudo apt-get install -y python3
sudo apt-get install -y python3-pip

# install docker
# install some pre-required packages that let apt use packages over HTTPS
sudo apt-get install -y ca-certificates curl gnupg lsb-release
# add the GPG key to the official Docker repository on your system
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add Docker repository to APT sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
# update the package db with the Docker packages from the newly added repository
sudo apt update
# install the docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# start docker
sudo systemctl restart docker

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# create the necessary folders to create the volumes for containers
sudo mkdir -p /data/db /data/uploads  

# clean up cached packages
sudo apt-get clean all
